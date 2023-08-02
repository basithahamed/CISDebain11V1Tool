#!/usr/bin/env bash

# Function to check if packet redirect sending is disabled
check_packet_redirect_sending_disabled() {
    l_output=""
    l_output2=""
    l_parlist="net.ipv4.conf.all.send_redirects=0
    net.ipv4.conf.default.send_redirects=0"
    l_searchloc="/run/sysctl.d/*.conf /etc/sysctl.d/*.conf
    /usr/local/lib/sysctl.d/*.conf /usr/lib/sysctl.d/*.conf /lib/sysctl.d/*.conf
    /etc/sysctl.conf $([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/
    {print $2}' /etc/default/ufw)"

    KPC() {
        l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)"
        l_pafile="$(grep -Psl -- "^\h*$l_kpname\h*=\h*$l_kpvalue\b\h*(#.*)?$" $l_searchloc)"
        l_fafile="$(grep -s -- "^\s*$l_kpname" $l_searchloc | grep -Pv -- "\h*=\h*$l_kpvalue\b\h*" | awk -F: '{print $1}')"

        if [ "$l_krp" = "$l_kpvalue" ]; then
            l_output="$l_output\n - \"$l_kpname\" is set to \"$l_kpvalue\" in the running configuration"
        else
            l_output2="$l_output2\n - \"$l_kpname\" is set to \"$l_krp\" in the running configuration"
        fi

        if [ -n "$l_pafile" ]; then
            l_output="$l_output\n - \"$l_kpname\" is set to \"$l_kpvalue\" in \"$l_pafile\""
        else
            l_output2="$l_output2\n - \"$l_kpname = $l_kpvalue\" is not set in a kernel parameter configuration file"
        fi

        [ -n "$l_fafile" ] && l_output2="$l_output2\n - \"$l_kpname\" is set incorrectly in \"$l_fafile\""
    }

    for l_kpe in $l_parlist; do
        l_kpname="$(awk -F= '{print $1}' <<< "$l_kpe")"
        l_kpvalue="$(awk -F= '{print $2}' <<< "$l_kpe")"
        KPC
    done

    # Report results. If no failures output in l_output2, we pass
    if [ -z "$l_output2" ]; then
        echo -e "\n3.2.1 Ensure packet redirect sending is disabled --> \033[0;32mpassed\033[0m"
        echo -e "Packet redirect sending is disabled.\n"
        return 0
    else
        echo -e "\n3.2.1 Ensure packet redirect sending is disabled --> \e[31mfailed\e[0m"
        echo -e "Packet redirect sending is enabled or not disabled.\n"
        [ -n "$l_output" ] && echo -e "\n$l_output\n"
        return 1
    fi
}

# Main script execution
check_packet_redirect_sending_disabled
