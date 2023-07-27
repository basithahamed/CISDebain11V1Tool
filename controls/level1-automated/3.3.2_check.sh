#!/usr/bin/env bash

# Function to check source routed packets are not accepted

# Function to check ICMP redirects are not accepted
check_icmp_redirects_not_accepted() {
    l_output=""
    l_output2=""
    l_parlist="net.ipv4.conf.all.accept_redirects=0
    net.ipv4.conf.default.accept_redirects=0
    net.ipv6.conf.all.accept_redirects=0
    net.ipv6.conf.default.accept_redirects=0"
    l_searchloc="/run/sysctl.d/*.conf /etc/sysctl.d/*.conf
    /usr/local/lib/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf
    /etc/sysctl.conf $([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/
    {print $2}' /etc/default/ufw)"

    # ... (same KPC() and ipv6_chk() functions as before)

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
        echo -e "\n3.3.2 Ensure ICMP redirects are not accepted --> \e[32mPASS\e[0m"
        echo -e "ICMP redirects are not accepted.\n"
    else
        echo -e "\n3.3.2 Ensure ICMP redirects are not accepted --> \e[31mFAIL\e[0m"
        echo -e "ICMP redirects are accepted or not disabled.\n"
        [ -n "$l_output" ] && echo -e "Failed checks:\n$l_output\n"
        echo -e "Reason(s) for audit failure:\n$l_output2\n"
    fi
}

# Call the functions to check audit rules
check_source_routed_packets_not_accepted
check_icmp_redirects_not_accepted

# ... (add other audit rules if needed)
