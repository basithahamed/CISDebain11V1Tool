#!/usr/bin/env bash

# Function to check if GNOME Desktop Manager is installed
check_gdm_installed() {
  if command -v dpkg-query > /dev/null 2>&1; then
    dpkg-query -W gdm gdm3 > /dev/null 2>&1
  elif command -v rpm > /dev/null 2>&1; then
    rpm -q gdm gdm3 > /dev/null 2>&1
  fi
}

# Function to check if GDM autorun-never is not overridden
check_gdm_autorun_never() {
  l_pkgoutput=""
  l_output=""
  l_output2=""
  l_gpname="local" # Set to desired dconf profile name (default is local)

  # Look for existing settings and set variables if they exist
  l_kfile="$(grep -Prils -- '^\h*autorun-never\b' /etc/dconf/db/*/ 2>/dev/null | awk -F'/' '{split($(NF-1),a,".");print a[1]}').d" # set directory of key file to be locked

  # Set profile name based on dconf db directory ({PROFILE_NAME}.d)
  if [ -f "$l_kfile" ]; then
    l_gpname="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile")"
  fi

  [ ! -f "$l_kfile" ] && l_kfile="/etc/dconf/db/$l_gpname.d/00-media-autorun"

  # Check if profile file exists
  if grep -Pq -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/* 2>/dev/null; then
    l_output="$l_output\n - dconf database profile exists in: \"$(grep -Pl -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/* 2>/dev/null)\""
  else
    l_gpfile="/etc/dconf/profile/user"
    echo -e " - creating dconf database profile"
    {
      echo -e "\nuser-db:user"
      echo "system-db:$l_gpname"
    } >> "$l_gpfile"
  fi

  # Create dconf directory if it doesn't exist
  l_gpdir="/etc/dconf/db/$l_gpname.d"
  if [ -d "$l_gpdir" ]; then
    l_output="$l_output\n - The dconf database directory \"$l_gpdir\" exists"
  else
    l_output="$l_output\n - creating dconf database directory \"$l_gpdir\""
    mkdir -p "$l_gpdir"
  fi

  # Check autorun-never setting
  if grep -Pqs -- '^\h*autorun-never\h*=\h*true\b' "$l_kfile" 2>/dev/null; then
    l_output="$l_output\n - \"autorun-never\" is locked in: \"$l_kfile\""
  else
    l_output="$l_output\n - \"autorun-never\" is not locked"
  fi

  # Check if GNOME Desktop Manager is installed
  if check_gdm_installed; then
    [ -n "$l_output2" ] && echo -e "1.8.9 Ensure GDM autorun-never is not overridden --> \e[31mfailed\e[0m$l_output2" || echo -e "1.8.9 Ensure GDM autorun-never is not overridden --> \033[0;32mpassed\033[0m"
  else
    echo -e "1.8.9 Ensure GDM autorun-never is not overridden --> \033[0;32mpassed\033[0m- GNOME Desktop Manager isn't installed\n- Recommendation is Not Applicable"
  fi

  # Update dconf database if the dconf command is available
  if command -v dconf > /dev/null 2>&1; then
    dconf update
  else
    echo "dconf command not found. Skipping dconf update."
  fi
}

# Main script execution
check_gdm_autorun_never
