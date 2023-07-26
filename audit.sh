#!/bin/bash

# Function to check if the script is running with root privileges
check_root_privileges() {
    if [ "$EUID" -ne 0 ]; then
        echo "This script must be run with root privileges. Use sudo or run as root user."
        exit 1
    fi
}

# Function to call a check script and get the result
chmod +x controls/*/*.sh
check() {
    local script_path="$1"

    if [ -x "$script_path" ]; then
        local result=$("$script_path")
        echo -e "$result"
    else
        echo -e "\033[0;31mError: Check script $script_path not found or not executable.\033[0m"
    fi
}

# Function to print colored output
print_colored() {
    if [ "$1" = "pass" ]; then
        echo -e "\033[0;32m$2\033[0m" # Green color for "pass"
    elif [ "$1" = "fail" ]; then
        echo -e "\033[0;31m$2\033[0m" # Red color for "fail"
    elif [ "$1" = "blue" ]; then
        echo -e "\033[0;34m$2\033[0m" # Blue color for "blue"
    else
        echo "$2"
    fi
}

# Function to calculate the percentage of checks passed
calculate_percentage() {
    local passed_checks="$1"
    local total_checks="$2"

    if [ "$total_checks" -gt 0 ]; then
        local percentage=$((passed_checks * 100 / total_checks))
        echo "$percentage"
    else
        echo "0"
    fi
}

# Check for root privileges
check_root_privileges

# Initialize variables for counting passed and failed checks
total_checks_automated_level1=0
passed_checks_automated_level1=0
total_checks_manual_level1=0
passed_checks_manual_level1=0

total_checks_automated_level2=0
passed_checks_automated_level2=0
total_checks_manual_level2=0
passed_checks_manual_level2=0

# Function to print the check result for Level1-Automated
print_result_automated_level1() {
    echo -e "Level1-Automated\n"
    if [ -n "$(find ./controls/level1-automated -maxdepth 1 -type f -name '*_check.sh')" ]; then
        for check_script in ./controls/level1-automated/*_check.sh; do
            result=$(check "$check_script")
            echo -e "$(print_colored "${result##*:}" "${result%:*}")"
            ((total_checks_automated_level1+=1))
            if echo "$result" | grep -q "pass"; then
                ((passed_checks_automated_level1+=1))
            fi
        done
    else
        echo -e "$(print_colored "blue" "No controls found in Level1-Automated.")"
    fi
}

# Function to print the check result for Level1-Manual
print_result_manual_level1() {
    echo -e "\nLevel1-Manual\n"
    if [ -n "$(find ./controls/level1-manual -maxdepth 1 -type f -name '*_check.sh')" ]; then
        for check_script in ./controls/level1-manual/*_check.sh; do
            result=$(check "$check_script")
            echo -e "$(print_colored "${result##*:}" "${result%:*}")"
            ((total_checks_manual_level1+=1))
            if echo "$result" | grep -q "pass"; then
                ((passed_checks_manual_level1+=1))
            fi
        done
    else
        echo -e "$(print_colored "blue" "No controls found in Level1-Manual.")"
    fi
}

# Function to print the check result for Level2-Automated
print_result_automated_level2() {
    echo -e "\nLevel2-Automated\n"
    if [ -n "$(find ./controls/level2-automated -maxdepth 1 -type f -name '*_check.sh')" ]; then
        for check_script in ./controls/level2-automated/*_check.sh; do
            result=$(check "$check_script")
            echo -e "$(print_colored "${result##*:}" "${result%:*}")"
            ((total_checks_automated_level2+=1))
            if echo "$result" | grep -q "pass"; then
                ((passed_checks_automated_level2+=1))
            fi
        done
    else
        echo -e "$(print_colored "blue" "No controls found in Level2-Automated.")"
    fi
}

# Function to print the check result for Level2-Manual
print_result_manual_level2() {
    echo -e "\nLevel2-Manual\n"
    if [ -n "$(find ./controls/level2-manual -maxdepth 1 -type f -name '*_check.sh')" ]; then
        for check_script in ./controls/level2-manual/*_check.sh; do
            result=$(check "$check_script")
            echo -e "$(print_colored "${result##*:}" "${result%:*}")"
            ((total_checks_manual_level2+=1))
            if echo "$result" | grep -q "pass"; then
                ((passed_checks_manual_level2+=1))
            fi
        done
    else
        echo -e "$(print_colored "blue" "No controls found in Level2-Manual.")"
    fi
}

# Call the function to print the result for Level1-Automated
print_result_automated_level1

# Call the function to print the result for Level1-Manual
print_result_manual_level1

# Call the function to print the result for Level2-Automated
print_result_automated_level2

# Call the function to print the result for Level2-Manual
print_result_manual_level2

echo -e "\n----------------------------------------------"

# Calculate the percentage of checks passed for Level1-Automated and Level1-Manual
percentage_automated_level1=$(calculate_percentage "$passed_checks_automated_level1" "$total_checks_automated_level1")
percentage_manual_level1=$(calculate_percentage "$passed_checks_manual_level1" "$total_checks_manual_level1")

# Calculate the percentage of checks passed for Level2-Automated and Level2-Manual
percentage_automated_level2=$(calculate_percentage "$passed_checks_automated_level2" "$total_checks_automated_level2")
percentage_manual_level2=$(calculate_percentage "$passed_checks_manual_level2" "$total_checks_manual_level2")

# Display the summary with the score and percentage information in white color
echo -e "\033[0mLevel1-Automated Score: $percentage_automated_level1%"
echo -e "Level1-Manual Score: $percentage_manual_level1%"

echo -e "\nLevel2-Automated Score: $percentage_automated_level2%"
echo -e "Level2-Manual Score: $percentage_manual_level2%"

total_checks_automated=$((total_checks_automated_level1 + total_checks_automated_level2))
passed_checks_automated=$((passed_checks_automated_level1 + passed_checks_automated_level2))

echo -e "\nTotal Automated Checks: $total_checks_automated"
echo -e "Automated Checks Passed: $passed_checks_automated"

# Calculate the overall percentage of automated checks passed
percentage_overall_automated=$(calculate_percentage "$passed_checks_automated" "$total_checks_automated")

echo -e "Automated Checks Percentage Passed: $percentage_overall_automated%"

# Check if the automated checks meet compliance requirements based on the overall percentage
if [ "$percentage_overall_automated" -eq 100 ]; then
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;32mThe automated checks meet compliance requirements.\033[0m"
else
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;31mThe automated checks do not meet compliance requirements.\033[0m"
fi

echo -e "\n----------------------------------------------"

total_checks_manual=$((total_checks_manual_level1 + total_checks_manual_level2))
passed_checks_manual=$((passed_checks_manual_level1 + passed_checks_manual_level2))

echo -e "\nTotal Manual Checks: $total_checks_manual"
echo -e "Manual Checks Passed: $passed_checks_manual"

# Calculate the overall percentage of manual checks passed
percentage_overall_manual=$(calculate_percentage "$passed_checks_manual" "$total_checks_manual")

echo -e "Manual Checks Percentage Passed: $percentage_overall_manual%"

# Check if the manual checks meet compliance requirements based on the overall percentage
if [ "$percentage_overall_manual" -eq 100 ]; then
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;32mThe manual checks meet compliance requirements.\033[0m"
else
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;31mThe manual checks do not meet compliance requirements.\033[0m"
fi

echo -e "\n----------------------------------------------"

# Calculate the total checks and passed checks
total_checks=$((total_checks_automated + total_checks_manual))
total_passed=$((passed_checks_automated + passed_checks_manual))

echo -e "\nTotal Checks: $total_checks"
echo -e "Passed Checks: $total_passed"
echo -e "Failed Checks: $((total_checks - total_passed))"

# Calculate the overall percentage of checks passed
percentage_overall=$(calculate_percentage "$total_passed" "$total_checks")

echo -e "Percentage Passed: $percentage_overall%"

# Check if the system meets compliance requirements based on the overall percentage
if [ "$percentage_overall" -eq 100 ]; then
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;32mThe system meets compliance requirements.\033[0m"
else
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;31mThe system does not meet compliance requirements.\033[0m"
fi
