#!/usr/bin/env bash

# Function to check if IPv6 is enabled
check_ipv6_enabled() {
  output=""
  grubfile=$(find /boot -type f \( -name 'grubenv' -o -name 'grub.conf' -o -name 'grub.cfg' \) -exec grep -Pl -- '^\h*(kernelopts=|linux|kernel)' {} \;)
  searchloc="/run/sysctl.d/*.conf /etc/sysctl.d/*.conf /usr/local/lib/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf"

  if [ -s "$grubfile" ]; then
    if ! grep -P -- "^\h*(kernelopts=|linux|kernel)" "$grubfile" | grep -vq -- ipv6.disable=1; then
      output="IPv6 Disabled in \"$grubfile\""
    fi
  fi

  if grep -Pqs -- "^\h*net\.ipv6\.conf\.all\.disable_ipv6\h*=\h*1\h*(#.*)?$" $searchloc && \
     grep -Pqs -- "^\h*net\.ipv6\.conf\.default\.disable_ipv6\h*=\h*1\h*(#.*)?$" $searchloc && \
     sysctl net.ipv6.conf.all.disable_ipv6 | grep -Pqs -- "^\h*net\.ipv6\.conf\.all\.disable_ipv6\h*=\h*1\h*(#.*)?$" && \
     sysctl net.ipv6.conf.default.disable_ipv6 | grep -Pqs -- "^\h*net\.ipv6\.conf\.default\.disable_ipv6\h*=\h*1\h*(#.*)?$"; then
    if [ -n "$output" ]; then
      output="$output, and in sysctl config"
    else
      output="IPv6 disabled in sysctl config"
    fi
  fi

  if [ -n "$output" ]; then
    echo -e "\n3.1.1 Ensure system is checked to determine if IPv6 is enabled --> \033[0;31mfailed\033[0m"
    echo "$output"
    return 1
  else
    echo -e "\n3.1.1 Ensure system is checked to determine if IPv6 is enabled --> \033[0;32mpassed\033[0m"
    echo "IPv6 is enabled on the system."
    return 0
  fi
}

# Main script execution
check_ipv6_enabled
