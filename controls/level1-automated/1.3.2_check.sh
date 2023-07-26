#!/bin/bash

# Function to check if AIDE cron job is configured
check_aide_cron_job() {
    if grep -q '/usr/sbin/aide' /etc/crontab; then
        echo -e "1.3.2 Ensure filesystem integrity is regularly checked --> \033[0;32mpass\033[0m"
    else
        echo -e "1.3.2 Ensure filesystem integrity is regularly checked --> \033[0;31mfail\033[0m (AIDE cron job not configured)"
    fi
}

# Call the function to check if AIDE cron job is configured
check_aide_cron_job
