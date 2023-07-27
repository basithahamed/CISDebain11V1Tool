#!/usr/bin/env bash

check_ipv6_router_advertisements() {
    local l_output=""
    local l_output2=""
    local l_parlist=("net.ipv6.conf.all.accept_ra=0" "net.ipv6.conf.default.accept_ra=0")
    local l_searchloc="/run/sysctl.d/*.conf /etc/sysctl.d/*.conf /usr/local/lib/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf /etc/sysctl.conf $([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/{print $2}' /etc/default/ufw)"

    KPC() {
        local l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)"
        local l_pafile="$(grep -Psl -- "^\h*$l_kpname\h*=\h*$l_kpvalue\b\h*(#.*)?$" "$l_searchloc")"
        local l_fafile="$(grep -s -- "^\s*$l_kpname" "$l_searchloc" | grep -Pv -- "\h*=\h*$l_kpvalue\b\h*" | awk -F: '{print $1}')"

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

    for l_kpe in "${l_parlist[@]}"; do
        local l_kpname="$(awk -F= '{print $1}' <<< "$l_kpe")"
        local l_kpvalue="$(awk -F= '{print $2}' <<< "$l_kpe")"
        KPC
    done

    if [ -z "$l_output2" ]; then
        echo -e "3.3.9 Ensure IPv6 router advertisements are not accepted - \e[32mPass\e[0m"
        [ -n "$l_output" ] && echo -e "Details:\n$l_output\n"
    else
        echo -e "3.3.9 Ensure IPv6 router advertisements are not accepted - \e[31mFail\e[0m"
        echo -e "\nReason(s) for audit failure:\n$l_output2\n"
        [ -n "$l_output" ] && echo -e "Details:\n$l_output\n"
    fi
}

# Call the function to check the audit rule
check_ipv6_router_advertisements
