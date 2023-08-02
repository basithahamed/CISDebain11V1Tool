#!/usr/bin/env bash

# Function to check if GDM is installed
check_gdm_installed() {
  if command -v dpkg-query > /dev/null 2>&1; then
    dpkg-query -W gdm gdm3 > /dev/null 2>&1
  elif command -v rpm > /dev/null 2>&1; then
    rpm -q gdm gdm3 > /dev/null 2>&1
  fi
}

# Function to check GDM screen lock configuration
check_gdm_screen_lock() {
  local l_idmv=900
  local l_ldmv=5

  local l_kfile="$(grep -Psril '^\h*idle-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/)"

  if [ -n "$l_kfile" ]; then
    local l_profile="$(awk -F'/' '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile")"
    local l_idv="$(awk -F 'uint32' '/idle-delay/{print $2}' "$l_kfile" | xargs)"

    local l_output=""
    local l_output2=""

    if [ -n "$l_idv" ]; then
      if [ "$l_idv" -gt "0" ] && [ "$l_idv" -le "$l_idmv" ]; then
        l_output+="\n- The \"idle-delay\" option is set to \"$l_idv\" seconds in \"$l_kfile\""
      elif [ "$l_idv" = "0" ]; then
        l_output2+="\n- The \"idle-delay\" option is set to \"$l_idv\" (disabled) in \"$l_kfile\""
      elif [ "$l_idv" -gt "$l_idmv" ]; then
        l_output2+="\n- The \"idle-delay\" option is set to \"$l_idv\" seconds (greater than $l_idmv) in \"$l_kfile\""
      fi
    else
      l_output2+="\n- The \"idle-delay\" option is not set in \"$l_kfile\""
    fi

    local l_ldv="$(awk -F 'uint32' '/lock-delay/{print $2}' "$l_kfile" | xargs)"

    if [ -n "$l_ldv" ]; then
      if [ "$l_ldv" -ge "0" ] && [ "$l_ldv" -le "$l_ldmv" ]; then
        l_output+="\n- The \"lock-delay\" option is set to \"$l_ldv\" seconds in \"$l_kfile\""
      elif [ "$l_ldv" -gt "$l_ldmv" ]; then
        l_output2+="\n- The \"lock-delay\" option is set to \"$l_ldv\" seconds (greater than $l_ldmv) in \"$l_kfile\""
      fi
    else
      l_output2+="\n- The \"lock-delay\" option is not set in \"$l_kfile\""
    fi

    if grep -Psq "^\h*system-db:$l_profile" /etc/dconf/profile/*; then
      l_output+="\n- The \"$l_profile\" profile exists"
    else
      l_output2+="\n- The \"$l_profile\" doesn't exist"
    fi

    if [ -f "/etc/dconf/db/$l_profile" ]; then
      l_output+="\n- The \"$l_profile\" profile exists in the dconf database"
    else
      l_output2+="\n- The \"$l_profile\" profile doesn't exist in the dconf database"
    fi

    if [ -z "$l_output2" ]; then
      echo -e "1.8.4 Ensure GDM screen locks when the user is idle --> \033[0;32mpassed\033[0m$l_output"
    else
      echo -e "1.8.4 Ensure GDM screen locks when the user is idle --> \e[31mfailed\e[0m$l_output2"
      [ -n "$l_output" ] && echo -e "- Correctly set:$l_output"
    fi
  else
    echo -e "1.8.4 Ensure GDM screen locks when the user is idle --> \033[0;32mpassed\033[0m- GNOME Desktop Manager isn't installed\n- Recommendation is Not Applicable"
  fi
}

# Main script execution
if check_gdm_installed; then
  check_gdm_screen_lock
else
  echo -e "1.8.4 Ensure GDM screen locks when the user is idle --> \033[0;32mpassed\033[0m- GNOME Desktop Manager isn't installed\n- Recommendation is Not Applicable"
fi
