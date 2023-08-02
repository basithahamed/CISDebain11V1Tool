#!/bin/bash

# Function to check if AppArmor is installed and enabled
check_apparmor() {
    if command -v apparmor_status >/dev/null 2>&1; then
        if [ -f "/etc/apparmor/parser.conf" ] && [ -f "/etc/apparmor/subdomain.conf" ]; then
            check_profiles_mode
        else
            echo -e "1.6.1.3 Ensure all AppArmor Profiles are in enforce or complain mode --> \033[0;32mpassed\033[0m (AppArmor is installed but no profiles found)"
        fi
    else
        echo -e "1.6.1.3 Ensure all AppArmor Profiles are in enforce or complain mode --> \033[0;31mfailed\033[0m (AppArmor is not installed)"
    fi
}

# Function to check the mode of all AppArmor profiles
check_profiles_mode() {
    local all_profiles_enforce_or_complain=true

    for profile in $(sudo apparmor_status | awk '/profiles/{print $2}'); do
        mode=$(sudo apparmor_status | awk -v profile="$profile" '$2 == profile {print $3}')
        if [[ "$mode" != "enforce" && "$mode" != "complain" ]]; then
            all_profiles_enforce_or_complain=false
            break
        fi
    done

    if "$all_profiles_enforce_or_complain"; then
        echo -e "1.6.1.3 Ensure all AppArmor Profiles are in enforce or complain mode --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.6.1.3 Ensure all AppArmor Profiles are in enforce or complain mode --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check AppArmor
check_apparmor
