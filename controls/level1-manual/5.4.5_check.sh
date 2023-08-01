#!/usr/bin/env bash

# Function to check if a user's password uses the configured hashing algorithm
check_user_password_hash() {
    local user=$1
    local configured_hash=$2
    local current_hash=$(awk -F '$' '{print $2}' <<< "$user")

    for hash in "${!HASH_MAP[@]}"; do
        if [[ "${hash}" == "${current_hash}" && "${HASH_MAP[$hash]}" != "${configured_hash^^}" ]]; then
            echo "The password for '${user}' is using '${HASH_MAP[$hash]}' instead of the configured '${configured_hash}'."
            return 1
        fi
    done

    return 0
}

# Function to print the result in the correct format
print_result() {
    local status=$1
    local message=$2

    if [ "$status" == "fail" ]; then
        echo -e "$message --> \e[31mFail\e[0m"
    else
        echo -e "$message --> \e[32mPass\e[0m"
    fi
}

# Create a hash map of the known hashing algorithms
declare -A HASH_MAP=( ["y"]="yescrypt" ["1"]="md5" ["2"]="blowfish" ["5"]="SHA256" ["6"]="SHA512" ["g"]="gost-yescrypt" )

# Get the currently configured hashing algorithm from /etc/login.defs
CONFIGURED_HASH=$(grep -i "^\s*ENCRYPT_METHOD\s*yescrypt\s*$" /etc/login.defs | awk '{print $2}')

# Variable to track the overall result
overall_result="pass"

# Check each user's password hashing algorithm in /etc/shadow
while IFS=: read -r user _; do
    if ! check_user_password_hash "$user" "$CONFIGURED_HASH"; then
        overall_result="fail"
    fi
done < /etc/shadow

# Print the overall result
print_result "$overall_result" "5.4.5 Ensure all current passwords use the configured hashing algorithm"
