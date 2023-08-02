    #!/bin/bash

    # Function to check if sudo commands use pty
    

    # Function to check if sudo has a custom log file configured
    check_sudo_custom_log() {
        custom_log=$(grep -rPi '^\h*Defaults\h+logfile=' /etc/sudoers*)
        if [ -n "$custom_log" ]; then
            echo -e "\n5.3.3 Ensure sudo has a custom log file configured --> \033[0;32mpassed\033[0m"
            echo -e "\n$custom_log\n"
        else
            echo -e "\n5.3.3 Ensure sudo has a custom log file configured --> \e[31mfailed\e[0m"
            echo -e "\nCustom log file configuration not found in /etc/sudoers.\n"
        fi
    }

    # Call the function to check sudo commands use pty


    # Call the function to check sudo custom log
    check_sudo_custom_log
