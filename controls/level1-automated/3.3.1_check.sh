#!/usr/bin/env bash

# Function to check source routed packets are not accepted
check_source_routed_packets_not_accepted() {
    {
        l_output=""
        l_output2=""
        l_parlist="net.ipv4.conf.all.accept_source_route=0
        net.ipv4.conf.default.accept_source_route=0
        net.ipv6.conf.all.accept_source_route=0
        net.ipv6.conf.default.accept_source_route=0"
        l_searchloc="/run/sysctl.d/*.conf /etc/sysctl.d/*.conf
        /usr/local/lib/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf
        /etc/sysctl.conf $([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/
        {print $2}' /etc/default/ufw)"

        KPC() {
            local l_krp="$(sysctl -n "$l_kpname")"
            local l_pafile="$(grep -Psl -- "^\h*$l_kpname\h*=\h*$l_kpvalue\b\h*(#.*)?$" $l_searchloc)"
            local l_fafile="$(grep -s -- "^\s*$l_kpname" $l_searchloc | grep -Pv -- "\h*=\h*$l_kpvalue\b\h*" | awk -F: '{print $1}')"

            if [ "$l_krp" -eq "$l_kpvalue" ]; then
                l_output="$l_output\n - \"$l_kpname\" is set to \"$l_kpvalue\" in the running configuration"
            else
                l_output2="$l_output2\n - \"$l_kpname\" is set to \"$l_krp\" in the running configuration"
            fi

            if [ -n "$l_pafile" ]; then
                l_output="$l_output\n - \"$l_kpname\" is set to \"$l_kpvalue\" in \"$l_pafile\""
            else
                l_output2="$l_output2\n - \"$l_kpname=$l_kpvalue\" is not set in a kernel parameter configuration file"
            fi

            [ -n "$l_fafile" ] && l_output2="$l_output2\n - \"$l_kpname\" is set incorrectly in \"$l_fafile\""
        }

        ipv6_chk() {
            local l_ipv6s=""
            local grubfile=$(find /boot -type f \( -name 'grubenv' -o -name 'grub.conf' -o -name 'grub.cfg' \) -exec grep -Pl -- '^\h*(kernelopts=|linux|kernel)' {} \;)

            if [ -s "$grubfile" ]; then
                ! grep -P -- "^\h*(kernelopts=|linux|kernel)" "$grubfile" | grep -vq -- ipv6.disable=1 && l_ipv6s="disabled"
            fi

            if grep -Pqs -- "^\h*net\.ipv6\.conf\.all\.disable_ipv6\h*=\h*1\h*(#.*)?$" $l_searchloc && \
                grep -Pqs -- "^\h*net\.ipv6\.conf\.default\.disable_ipv6\h*=\h*1\h*(#.*)?$" $l_searchloc && \
                sysctl net.ipv6.conf.all.disable_ipv6 | grep -Pqs -- "^\h*net\.ipv6\.conf\.all\.disable_ipv6\h*=\h*1\h*(#.*)?$" && \
                sysctl net.ipv6.conf.default.disable_ipv6 | grep -Pqs -- "^\h*net\.ipv6\.conf\.default\.disable_ipv6\h*=\h*1\h*(#.*)?$"; then
                l_ipv6s="disabled"
            fi

            if [ -n "$l_ipv6s" ]; then
                l_output="$l_output\n - IPv6 is disabled on the system, \"$l_kpname\" is not applicable"
            else
                KPC
            fi
        }

        for l_kpe in $l_parlist; do
            l_kpname="$(awk -F= '{print $1}' <<< "$l_kpe")"
            l_kpvalue="$(awk -F= '{print $2}' <<< "$l_kpe")"

            if grep -q '^net.ipv6.' <<< "$l_kpe"; then
                ipv6_chk
            else
                KPC
            fi
        done

        if [ -z "$l_output2" ]; then
            echo -e "\n3.3.1 Ensure source routed packets are not accepted --> \033[0;32mpassed\033[0m"
            echo -e "Source routed packets are not accepted.\n"
        else
            echo -e "\n3.3.1 Ensure source routed packets are not accepted --> \e[31mfailed\e[0m"
            echo -e "Source routed packets are accepted or not disabled.\n"
            [ -n "$l_output" ] && echo -e "Failed checks:\n$l_output\n"
            echo -e "Reason(s) for audit failure:\n$l_output2\n"
        fi
    }
}

# Function to check other audit rules...

# Call the functions to check audit rules
check_source_routed_packets_not_accepted

# Call other audit rules...

