#!/usr/bin/env bash

# Function to check if GNOME Desktop Manager is installed
check_gdm_installed() {
  if command -v dpkg-query > /dev/null 2>&1; then
    dpkg-query -W gdm gdm3 > /dev/null 2>&1
  elif command -v rpm > /dev/null 2>&1; then
    rpm -q gdm gdm3 > /dev/null 2>&1
  fi
}

# Function to check if GDM automatic mounting of removable media is disabled
check_gdm_automatic_mounting() {
  l_pkgoutput=""
  l_output=""
  l_output2=""

  # Look for existing settings and set variables if they exist
  l_kfile="$(grep -Prils -- '^\h*automount\b' /etc/dconf/db/*.d)"
  l_kfile2="$(grep -Prils -- '^\h*automount-open\b' /etc/dconf/db/*.d)"

  # Set profile name based on dconf db directory ({PROFILE_NAME}.d)
  if [ -f "$l_kfile" ]; then
    l_gpname="$(awk -F'/' '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile")"
  elif [ -f "$l_kfile2" ]; then
    l_gpname="$(awk -F'/' '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile2")"
  fi

  # If the profile name exists, continue checks
  if [ -n "$l_gpname" ]; then
    l_gpdir="/etc/dconf/db/$l_gpname.d"

    # Check if profile file exists
    if grep -Pq -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*; then
      l_output="$l_output\n - dconf database profile file \"$(grep -Pl -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*)\" exists"
    else
      l_output2="$l_output2\n - dconf database profile isn't set"
    fi

    # Check if the dconf database file exists
    if [ -f "/etc/dconf/db/$l_gpname" ]; then
      l_output="$l_output\n - The dconf database \"$l_gpname\" exists"
    else
      l_output2="$l_output2\n - The dconf database \"$l_gpname\" doesn't exist"
    fi

    # Check if the dconf database directory exists
    if [ -d "$l_gpdir" ]; then
      l_output="$l_output\n - The dconf directory \"$l_gpdir\" exists"
    else
      l_output2="$l_output2\n - The dconf directory \"$l_gpdir\" doesn't exist"
    fi

    # Check automount setting
    if grep -Pqrs -- '^\h*automount\h*=\h*false\b' "$l_kfile"; then
      l_output="$l_output\n - \"automount\" is set to false in: \"$l_kfile\""
    else
      l_output2="$l_output2\n - \"automount\" is not set correctly"
    fi

    # Check automount-open setting
    if grep -Pqs -- '^\h*automount-open\h*=\h*false\b' "$l_kfile2"; then
      l_output="$l_output\n - \"automount-open\" is set to false in: \"$l_kfile2\""
    else
      l_output2="$l_output2\n - \"automount-open\" is not set correctly"
    fi
  else
    # Settings don't exist. Nothing further to check
    l_output2="$l_output2\n - neither \"automount\" nor \"automount-open\" is set"
  fi

  # Check if GNOME Desktop Manager is installed
  if check_gdm_installed; then
    [ -n "$l_output2" ] && echo -e "1.8.6 Ensure GDM automatic mounting of removable media is disabled --> \e[31mFAIL\e[0m$l_output2" || echo -e "1.8.6 Ensure GDM automatic mounting of removable media is disabled --> \e[32mPASS\e[0m$l_output"
  else
    echo -e "1.8.6 Ensure GDM automatic mounting of removable media is disabled --> \e[32mPASS\e[0m\n- GNOME Desktop Manager isn't installed\n- Recommendation is Not Applicable"
  fi
}

# Main script execution
check_gdm_automatic_mounting
