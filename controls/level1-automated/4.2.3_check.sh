#!/usr/bin/env bash

# Function to check log file permissions and ownership
check_log_permissions_ownership() {
    # echo -e "\n4.2.3 Ensure all logfiles have appropriate permissions and ownership"
    output=""
    
    while read -r fname; do
        bname="$(basename "$fname")"
        case "$bname" in
            lastlog | lastlog.* | wtmp | wtmp.* | btmp | btmp.*)
                if ! stat -Lc "%a" "$fname" | grep -Pq -- '^\h*[0,2,4,6][0,2,4,6][0,4]\h*$'; then
                    output="$output\n- File: \"$fname\" mode: \"$(stat -Lc "%a" "$fname")\""
                fi
                if ! stat -Lc "%U %G" "$fname" | grep -Pq -- '^\h*root\h+(utmp|root)\h*$'; then
                    output="$output\n  Ownership: \"$(stat -Lc "%U:%G" "$fname")\""
                fi
                ;;
            secure | auth.log)
                if ! stat -Lc "%a" "$fname" | grep -Pq -- '^\h*[0,2,4,6][0,4]0\h*$'; then
                    output="$output\n- File: \"$fname\" mode: \"$(stat -Lc "%a" "$fname")\""
                fi
                if ! stat -Lc "%U %G" "$fname" | grep -Pq -- '^\h*(syslog|root)\h+(adm|root)\h*$'; then
                    output="$output\n  Ownership: \"$(stat -Lc "%U:%G" "$fname")\""
                fi
                ;;
            SSSD | sssd)
                if ! stat -Lc "%a" "$fname" | grep -Pq -- '^\h*[0,2,4,6][0,2,4,6]0\h*$'; then
                    output="$output\n- File: \"$fname\" mode: \"$(stat -Lc "%a" "$fname")\""
                fi
                if ! stat -Lc "%U %G" "$fname" | grep -Piq -- '^\h*(SSSD|root)\h+(SSSD|root)\h*$'; then
                    output="$output\n  Ownership: \"$(stat -Lc "%U:%G" "$fname")\""
                fi
                ;;
            gdm | gdm3)
                if ! stat -Lc "%a" "$fname" | grep -Pq -- '^\h*[0,2,4,6][0,2,4,6]0\h*$'; then
                    output="$output\n- File: \"$fname\" mode: \"$(stat -Lc "%a" "$fname")\""
                fi
                if ! stat -Lc "%U %G" "$fname" | grep -Pq -- '^\h*(root)\h+(gdm3?|root)\h*$'; then
                    output="$output\n  Ownership: \"$(stat -Lc "%U:%G" "$fname")\""
                fi
                ;;
            *.journal)
                if ! stat -Lc "%a" "$fname" | grep -Pq -- '^\h*[0,2,4,6][0,4]0\h*$'; then
                    output="$output\n- File: \"$fname\" mode: \"$(stat -Lc "%a" "$fname")\""
                fi
                if ! stat -Lc "%U %G" "$fname" | grep -Pq -- '^\h*(root)\h+(systemd-journal|root)\h*$'; then
                    output="$output\n  Ownership: \"$(stat -Lc "%U:%G" "$fname")\""
                fi
                ;;
            *)
                if ! stat -Lc "%a" "$fname" | grep -Pq -- '^\h*[0,2,4,6][0,4]0\h*$'; then
                    output="$output\n- File: \"$fname\" mode: \"$(stat -Lc "%a" "$fname")\""
                fi
                if ! stat -Lc "%U %G" "$fname" | grep -Pq -- '^\h*(syslog|root)\h+(adm|root)\h*$'; then
                    output="$output\n  Ownership: \"$(stat -Lc "%U:%G" "$fname")\""
                fi
                ;;
        esac
    done < <(find /var/log -type f)

    # If all files passed, then we pass
    if [ -z "$output" ]; then
        echo -e "4.2.3 Ensure all logfiles have appropriate permissions and ownership --> \e[32m- PASS\n- All files in \"/var/log/\" have appropriate permissions and ownership\e[0m"
    else
        # print the reason why we are failing
        echo -e "4.2.3 Ensure all logfiles have appropriate permissions and ownership --> \e[31mFAIL\e[0m$output"
    fi
    echo -e "- End check - logfiles have appropriate permissions and ownership\n"
}

# Call the function to check log file permissions and ownership
check_log_permissions_ownership