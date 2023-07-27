#!/usr/bin/env bash

check_auditd_installation() {
    local required_packages=("auditd" "audispd-plugins")
    local missing_packages=""

    for package in "${required_packages[@]}"; do
        if ! dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q 'install ok installed'; then
            missing_packages+="\n- $package is not installed"
        fi
    done

    if [ -z "$missing_packages" ]; then
        echo -e "4.1.1.1 Ensure auditd is installed - \e[32mPass\e[0m"
    else
        echo -e "4.1.1.1 Ensure auditd is installed - \e[31mFail\e[0m"
        echo -e "\nMissing packages:$missing_packages\n"
    fi
}

# Call the function to check the auditd installation
check_auditd_installation
