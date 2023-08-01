#!/usr/bin/env bash

# Function to check if rsyslog is configured to send logs to a remote log host
check_rsyslog_remote_logging() {
    local remote_loghost="loghost.example.com"
    local old_format_found=false
    local new_format_found=false

    # Check for old format
    if grep -qE "^*.*[^I][^I]*@" /etc/rsyslog.conf /etc/rsyslog.d/*.conf; then
        old_format_found=true
    fi

    # Check for new format
    if grep -qE '^\s*([^#]+\s+)?action\(([^#]+\s+)?\btarget=\"?[^#"]+\"?\b' /etc/rsyslog.conf /etc/rsyslog.d/*.conf; then
        new_format_found=true
    fi

    if $old_format_found || $new_format_found; then
        echo -e "\n4.2.2.6 Ensure rsyslog is configured to send logs to a remote log host --> \e[32mPASS\e[0m"
    else
        echo -e "\n4.2.2.6 Ensure rsyslog is configured to send logs to a remote log host --> \e[31mFAIL\e[0m"
    fi
}

# Call the function to check rsyslog remote logging configuration
check_rsyslog_remote_logging
