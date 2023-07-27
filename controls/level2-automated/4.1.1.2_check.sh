#!/usr/bin/env bash

check_auditd_service() {
    if systemctl is-enabled auditd &>/dev/null; then
        if systemctl is-active auditd &>/dev/null; then
            echo -e "4.1.1.2 Ensure auditd service is enabled and active - \e[32mPass\e[0m"
        else
            echo -e "4.1.1.2 Ensure auditd service is enabled and active - \e[31mFail\e[0m"
            echo -e "\nAuditd service is enabled but not active.\n"
        fi
    else
        echo -e "4.1.1.2 Ensure auditd service is enabled and active - \e[31mFail\e[0m"
        echo -e "\nAuditd service is not enabled.\n"
    fi
}

# Call the function to check the auditd service
check_auditd_service
