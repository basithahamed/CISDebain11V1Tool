#!/usr/bin/env bash

# Function to check logging configuration
check_logging_configuration() {
    local rsyslog_conf="/etc/rsyslog.conf"
    local rsyslog_d_conf="/etc/rsyslog.d/*.conf"
    local logging_configured=true

    # Check /etc/rsyslog.conf
    if ! grep -qE "^\s*[^#]*\*\.\*\s+/var/log/messages" "$rsyslog_conf" ||
       ! grep -qE "^\s*[^#]*\kern\.\*\s+/var/log/kern.log" "$rsyslog_conf" ||
       ! grep -qE "^\s*[^#]*\*\.\emerg\s+:omusrmsg:\*\*" "$rsyslog_conf" ||
       ! grep -qE "^\s*[^#]*\auth,\authpriv\.\*\s+/var/log/auth.log" "$rsyslog_conf" ||
       ! grep -qE "^\s*[^#]*\cron\.\*\s+/var/log/cron.log" "$rsyslog_conf" ||
       ! grep -qE "^\s*[^#]*\mail\.\*\s+/var/log/mail.log" "$rsyslog_conf" ||
       ! grep -qE "^\s*[^#]*\maillog\s+/var/log/mail.log" "$rsyslog_conf" ||
       ! grep -qE "^\s*[^#]*\lpr\.\*\s+/var/log/lpr.log" "$rsyslog_conf" ||
       ! grep -qE "^\s*[^#]*\user\.\*\s+/var/log/user.log" "$rsyslog_conf" ||
       ! grep -qE "^\s*[^#]*\local[0-7].*\s+/var/log/localmessages" "$rsyslog_conf"; then
        logging_configured=false
    fi

    # Check /etc/rsyslog.d/*.conf files
    for conf_file in $rsyslog_d_conf; do
        if ! grep -qE "^\s*[^#]*\*\.\*\s+/var/log/messages" "$conf_file" ||
           ! grep -qE "^\s*[^#]*\kern\.\*\s+/var/log/kern.log" "$conf_file" ||
           ! grep -qE "^\s*[^#]*\*\.\emerg\s+:omusrmsg:\*\*" "$conf_file" ||
           ! grep -qE "^\s*[^#]*\auth,\authpriv\.\*\s+/var/log/auth.log" "$conf_file" ||
           ! grep -qE "^\s*[^#]*\cron\.\*\s+/var/log/cron.log" "$conf_file" ||
           ! grep -qE "^\s*[^#]*\mail\.\*\s+/var/log/mail.log" "$conf_file" ||
           ! grep -qE "^\s*[^#]*\maillog\s+/var/log/mail.log" "$conf_file" ||
           ! grep -qE "^\s*[^#]*\lpr\.\*\s+/var/log/lpr.log" "$conf_file" ||
           ! grep -qE "^\s*[^#]*\user\.\*\s+/var/log/user.log" "$conf_file" ||
           ! grep -qE "^\s*[^#]*\local[0-7].*\s+/var/log/localmessages" "$conf_file"; then
            logging_configured=false
        fi
    done

    # Check if log files are logging information as expected
    local log_files=("messages" "kern.log" "auth.log" "cron.log" "mail.log" "lpr.log" "user.log" "localmessages")
    for log_file in "${log_files[@]}"; do
        if [ ! -f "/var/log/$log_file" ] || [ ! -s "/var/log/$log_file" ]; then
            logging_configured=false
            break
        fi
    done

    if $logging_configured; then
        echo -e "\n4.2.2.5 Ensure logging is configured --> \e[32mpassed\e[0m"
    else
        echo -e "\n4.2.2.5 Ensure logging is configured --> \e[31mfailed\e[0m"
    fi
}

# Call the function to check logging configuration
check_logging_configuration
