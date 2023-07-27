#!/bin/bash

# Function to check if the system is disabled when audit logs are full
check_audit_full_logs() {
    if ! dpkg -l auditd &>/dev/null; then
        echo -e "\n4.1.2.3 Ensure system is disabled when audit logs are full - \e[31mFail\e[0m"
        echo "auditd is not installed"
        exit 1
    fi

    local space_left_action
    local action_mail_acct
    local admin_space_left_action

    space_left_action=$(grep -Po '^\h*space_left_action\h*=\h*\K\S+' /etc/audit/auditd.conf)
    action_mail_acct=$(grep -Po '^\h*action_mail_acct\h*=\h*\K\S+' /etc/audit/auditd.conf)
    admin_space_left_action=$(grep -Po '^\h*admin_space_left_action\s*=\s*\K\S+' /etc/audit/auditd.conf)

    if [[ "$space_left_action" == "email" && "$action_mail_acct" == "root" && ("$admin_space_left_action" == "halt" || "$admin_space_left_action" == "single") ]]; then
        echo -e "\n4.1.2.3 Ensure system is disabled when audit logs are full - \e[32mPass\e[0m"
        echo "space_left_action = $space_left_action"
        echo "action_mail_acct = $action_mail_acct"
        echo "admin_space_left_action = $admin_space_left_action"
    else
        echo -e "\n4.1.2.3 Ensure system is disabled when audit logs are full - \e[31mFail\e[0m"
        echo "space_left_action = $space_left_action"
        echo "action_mail_acct = $action_mail_acct"
        echo "admin_space_left_action = $admin_space_left_action"
    fi
}

# Call the function to check if the system is disabled when audit logs are full
check_audit_full_logs
