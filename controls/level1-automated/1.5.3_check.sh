#!/bin/bash

# Function to check if Automatic Error Reporting is enabled
check_error_reporting_disabled() {
    if [ "$(systemctl is-active apport)" = "active" ] && [ "$(systemctl is-enabled apport)" = "enabled" ]; then
        echo -e "1.5.3 Ensure Automatic Error Reporting is not enabled --> \033[0;31mfail\033[0m (apport is enabled)"
    else
        echo -e "1.5.3 Ensure Automatic Error Reporting is not enabled --> \033[0;32mpass\033[0m"
    fi
}

# Call the function to check if Automatic Error Reporting is not enabled
check_error_reporting_disabled
