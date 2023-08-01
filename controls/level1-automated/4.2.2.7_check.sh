#!/usr/bin/env bash

# Function to check if rsyslog is not configured to receive logs from a remote client
check_rsyslog_no_remote_logs() {
    local old_format_found=false
    local new_format_found=false

    # Check for old format
    if grep -q '$ModLoad imtcp' /etc/rsyslog.conf /etc/rsyslog.d/*.conf || grep -q '$InputTCPServerRun' /etc/rsyslog.conf /etc/rsyslog.d/*.conf; then
        old_format_found=true
    fi

    # Check for new format
    if grep -q -P '^\h*module\(load="imtcp"\)' /etc/rsyslog.conf /etc/rsyslog.d/*.conf || grep -q -P '^\h*input\(type="imtcp" port="514"\)' /etc/rsyslog.conf /etc/rsyslog.d/*.conf; then
        new_format_found=true
    fi

    if ! $old_format_found && ! $new_format_found; then
        echo -e "\n4.2.7 Ensure rsyslog is not configured to receive logs from a remote client --> \e[32mPASS\e[0m"
    else
        echo -e "\n4.2.7 Ensure rsyslog is not configured to receive logs from a remote client --> \e[31mFAIL\e[0m"
    fi
}

# Call the function to check rsyslog remote logs configuration
check_rsyslog_no_remote_logs
