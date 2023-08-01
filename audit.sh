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
    if [ "$1" = "pass" ] || [ "$1" = "PASS" ]; then
        echo -e "\033[0;32m$2\033[0m" # Green color for "pass"
    elif [ "$1" = "fail" ] || [ "$1" = "FAIL" ]; then
        echo -e "\033[0;31m$2\033[0m" # Red color for "fail"
    elif [ "$1" = "blue" ]; then
        echo -e "\033[0;34m$2\033[0m" # Blue color for "blue"
    elif [ "$1" = "flashy_yellow" ]; then
        echo -e "\033[1;33m$2\033[0m" # Flashy Yellow color for "flashy_yellow"
    elif [ "$1" = "flashy_magenta" ]; then
        echo -e "\033[1;35m$2\033[0m" # Flashy Magenta color for "flashy_magenta"
    elif [ "$1" = "flashy_cyan" ]; then
        echo -e "\033[1;36m$2\033[0m" # Flashy Cyan color for "flashy_cyan"
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

# Function to convert check result to lowercase
convert_to_lowercase() {
    local result="$1"
    echo "${result,,}"
}

# Function to print the check result for Level1-Automated
print_result_automated_level1() {
    echo -e "$(print_colored "flashy_yellow" "Level1-Automated")\n"
    if [ -n "$(find ./controls/level1-automated -maxdepth 1 -type f -name '*_check.sh')" ]; then
        for check_script in ./controls/level1-automated/*_check.sh; do
            result=$(check "$check_script")
            result_lower=$(convert_to_lowercase "$result")  # Convert result to lowercase
            echo -e "$(print_colored "${result_lower##*:}" "${result_lower%:*}")"
            ((total_checks_automated_level1+=1))
            if echo "$result_lower" | grep -q "pass"; then
                ((passed_checks_automated_level1+=1))
            fi
        done
    else
        echo -e "$(print_colored "blue" "No controls found in Level1-Automated.")"
    fi
}

# Function to print the check result for Level1-Manual
print_result_manual_level1() {
    echo -e "\n$(print_colored "flashy_magenta" "Level1-Manual")\n"
    if [ -n "$(find ./controls/level1-manual -maxdepth 1 -type f -name '*_check.sh')" ]; then
        for check_script in ./controls/level1-manual/*_check.sh; do
            result=$(check "$check_script")
            result_lower=$(convert_to_lowercase "$result")  # Convert result to lowercase
            echo -e "$(print_colored "${result_lower##*:}" "${result_lower%:*}")"
            ((total_checks_manual_level1+=1))
            if echo "$result_lower" | grep -q "pass"; then
                ((passed_checks_manual_level1+=1))
            fi
        done
    else
        echo -e "$(print_colored "blue" "No controls found in Level1-Manual.")"
    fi
}

# Function to print the check result for Level2-Automated
print_result_automated_level2() {
    echo -e "\n$(print_colored "flashy_cyan" "Level2-Automated")\n"
    if [ -n "$(find ./controls/level2-automated -maxdepth 1 -type f -name '*_check.sh')" ]; then
        for check_script in ./controls/level2-automated/*_check.sh; do
            result=$(check "$check_script")
            result_lower=$(convert_to_lowercase "$result")  # Convert result to lowercase
            echo -e "$(print_colored "${result_lower##*:}" "${result_lower%:*}")"
            ((total_checks_automated_level2+=1))
            if echo "$result_lower" | grep -q "pass"; then
                ((passed_checks_automated_level2+=1))
            fi
        done
    else
        echo -e "$(print_colored "blue" "No controls found in Level2-Automated.")"
    fi
}

# Function to print the check result for Level2-Manual
print_result_manual_level2() {
    echo -e "\n$(print_colored "flashy_yellow" "Level2-Manual")\n"
    if [ -n "$(find ./controls/level2-manual -maxdepth 1 -type f -name '*_check.sh')" ]; then
        for check_script in ./controls/level2-manual/*_check.sh; do
            result=$(check "$check_script")
            result_lower=$(convert_to_lowercase "$result")  # Convert result to lowercase
            echo -e "$(print_colored "${result_lower##*:}" "${result_lower%:*}")"
            ((total_checks_manual_level2+=1))
            if echo "$result_lower" | grep -q "pass"; then
                ((passed_checks_manual_level2+=1))
            fi
        done
    else
        echo -e "$(print_colored "blue" "No controls found in Level2-Manual.")"
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

# Call the function to print the result for Level1-Automated
print_result_automated_level1

# Call the function to print the result for Level1-Manual
print_result_manual_level1

# Call the function to print the result for Level2-Automated
print_result_automated_level2

# Call the function to print the result for Level2-Manual
print_result_manual_level2

# Calculate the total checks and passed checks
total_checks_automated=$((total_checks_automated_level1 + total_checks_automated_level2))
passed_checks_automated=$((passed_checks_automated_level1 + passed_checks_automated_level2))

# Calculate the overall percentage of automated checks passed
percentage_overall_automated=$(calculate_percentage "$passed_checks_automated" "$total_checks_automated")

# Check if the automated checks meet compliance requirements based on the overall percentage
if [ "$percentage_overall_automated" -eq 100 ]; then
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;32mThe automated checks meet compliance requirements.\033[0m"
else
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;31mThe automated checks do not meet compliance requirements.\033[0m"
fi

# Calculate the total checks and passed checks for manual checks
total_checks_manual=$((total_checks_manual_level1 + total_checks_manual_level2))
passed_checks_manual=$((passed_checks_manual_level1 + passed_checks_manual_level2))

# Calculate the overall percentage of manual checks passed
percentage_overall_manual=$(calculate_percentage "$passed_checks_manual" "$total_checks_manual")

# Check if the manual checks meet compliance requirements based on the overall percentage
if [ "$percentage_overall_manual" -eq 100 ]; then
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;32mThe manual checks meet compliance requirements.\033[0m"
else
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;31mThe manual checks do not meet compliance requirements.\033[0m"
fi

# Calculate the total checks and passed checks for all levels
total_checks=$((total_checks_automated + total_checks_manual))
total_passed=$((passed_checks_automated + passed_checks_manual))

#!/bin/bash

# Function to check if the script is running with root privileges
#!/bin/bash

# ... (All the functions and the main part of the script are here)

# Calculate the scores for Level1-Automated, Level2-Automated, and Level1-Manual
percentage_level1_automated=$(calculate_percentage "$passed_checks_automated_level1" "$total_checks_automated_level1")
percentage_level2_automated=$(calculate_percentage "$passed_checks_automated_level2" "$total_checks_automated_level2")
percentage_combined_automated=$(calculate_percentage "$((passed_checks_automated_level1 + passed_checks_automated_level2))" "$((total_checks_automated_level1 + total_checks_automated_level2))")
percentage_level1_manual=$(calculate_percentage "$passed_checks_manual_level1" "$total_checks_manual_level1")
percentage_level2_manual=$(calculate_percentage "$passed_checks_manual_level2" "$total_checks_manual_level2")
percentage_combined_manual=$(calculate_percentage "$((passed_checks_manual_level1 + passed_checks_manual_level2))" "$((total_checks_manual_level1 + total_checks_manual_level2))")

# percentage_level1_automated=$(calculate_percentage "$passed_checks_automated_level1" "$total_checks_automated_level1")
# percentage_level2_automated=$(calculate_percentage "$passed_checks_automated_level2" "$total_checks_automated_level2")
# percentage_combined_automated=$(calculate_percentage "$((passed_checks_automated_level1 + passed_checks_automated_level2))" "$((total_checks_automated_level1 + total_checks_automated_level2))")
# percentage_level1_manual=$(calculate_percentage "$passed_checks_manual_level1" "$total_checks_manual_level1")
# percentage_level2_manual=$(calculate_percentage "$passed_checks_manual_level2" "$total_checks_manual_level2")
# percentage_combined_manual=$(calculate_percentage "$((passed_checks_manual_level1 + passed_checks_manual_level2))" "$((total_checks_manual_level1 + total_checks_manual_level2))")

# Calculate the combined total checks and passed checks for all levels
total_checks_combined=$((total_checks_automated + total_checks_manual))
total_passed_combined=$((passed_checks_automated + passed_checks_manual))
percentage_combined_overall=$(calculate_percentage "$total_passed_combined" "$total_checks_combined")

# Check if Level1-Automated meets compliance requirements
if [ "$percentage_level1_automated" -eq 100 ]; then
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;32mLevel1-Automated meets compliance requirements.\033[0m"
else
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;31mLevel1-Automated does not meet compliance requirements.\033[0m"
fi

# Check if Level2-Automated meets compliance requirements
if [ "$percentage_level2_automated" -eq 100 ]; then
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;32mLevel2-Automated meets compliance requirements.\033[0m"
else
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;31mLevel2-Automated does not meet compliance requirements.\033[0m"
fi

# Check if combined Level1-Automated and Level2-Automated meets compliance requirements
if [ "$percentage_combined_automated" -eq 100 ]; then
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;32mCombined Level1-Automated and Level2-Automated meet compliance requirements.\033[0m"
else
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;31mCombined Level1-Automated and Level2-Automated do not meet compliance requirements.\033[0m"
fi

# Check if Level1-Manual meets compliance requirements
if [ "$percentage_level1_manual" -eq 100 ]; then
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;32mLevel1-Manual meets compliance requirements.\033[0m"
else
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;31mLevel1-Manual does not meet compliance requirements.\033[0m"
fi

# Calculate the overall total checks and passed checks for all levels
total_checks_combined=$((total_checks_automated + total_checks_manual))
total_passed_combined=$((passed_checks_automated + passed_checks_manual))
percentage_combined_overall=$(calculate_percentage "$total_passed_combined" "$total_checks_combined")

# Check if the system meets compliance requirements based on the overall percentage
if [ "$percentage_combined_overall" -eq 100 ]; then
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;32mThe combined Level1-Automated, Level2-Automated, and Level1-Manual meet compliance requirements.\033[0m"
else
    echo -e "\033[0m----------------------------------------------"
    echo -e "\033[0;31mThe combined Level1-Automated, Level2-Automated, and Level1-Manual do not meet compliance requirements.\033[0m"
fi

# Print the combined compliance scores
# Print the combined compliance scores
echo -e "\nCombined Compliance Scores:"
echo "------------------------"
echo "Recommended and Must Have Controls"
echo "------------------------"

echo "Level1-Automated Total Checks:  $total_checks_automated_level1"
echo "Level1-Automated Passed Checks: $passed_checks_automated_level1"
echo "Level1-Automated Failed Checks: $((total_checks_automated_level1 - passed_checks_automated_level1))"
echo "Level1-Automated Score:         $percentage_level1_automated%"

echo "Level2-Automated Total Checks:  $total_checks_automated_level2"
echo "Level2-Automated Passed Checks: $passed_checks_automated_level2"
echo "Level2-Automated Failed Checks: $((total_checks_automated_level2 - passed_checks_automated_level2))"
echo "Level2-Automated Score:         $percentage_level2_automated%"

echo "Combined Automated Total Checks:  $((total_checks_automated_level1 + total_checks_automated_level2))"
echo "Combined Automated Passed Checks: $((passed_checks_automated_level1 + passed_checks_automated_level2))"
echo "Combined Automated Failed Checks: $(((total_checks_automated_level1 + total_checks_automated_level2) - (passed_checks_automated_level1 + passed_checks_automated_level2)))"
echo "Combined Automated Score:         $percentage_combined_automated%"

echo "------------------------"
echo "Recommended Controls"
echo "------------------------"

echo "Level1-Manual Total Checks:      $total_checks_manual_level1"
echo "Level1-Manual Passed Checks:     $passed_checks_manual_level1"
echo "Level1-Manual Failed Checks:     $((total_checks_manual_level1 - passed_checks_manual_level1))"
echo "Level1-Manual Score:             $percentage_level1_manual%"

echo "Level2-Manual Total Checks:      $total_checks_manual_level2"
echo "Level2-Manual Passed Checks:     $passed_checks_manual_level2"
echo "Level2-Manual Failed Checks:     $((total_checks_manual_level2 - passed_checks_manual_level2))"
echo "Level2-Manual Score:             $percentage_level2_manual%"

echo "Combined Manual Total Checks:    $((total_checks_manual_level1 + total_checks_manual_level2))"
echo "Combined Manual Passed Checks:   $((passed_checks_manual_level1 + passed_checks_manual_level2))"
echo "Combined Manual Failed Checks:   $(((total_checks_manual_level1 + total_checks_manual_level2) - (passed_checks_manual_level1 + passed_checks_manual_level2)))"
echo "Combined Manual Score:           $percentage_combined_manual%"

# Print the overall compliance score
echo "------------------------"
echo -e "Overall Compliance Score:"
echo "------------------------"
echo "Overall Total Checks:      $total_checks_combined"
echo "Overall Passed Checks:     $total_passed_combined"    
echo "Overall Failed Checks:     $((total_checks_combined - total_passed_combined))"
echo "Overall Score:             $percentage_combined_overall%"
