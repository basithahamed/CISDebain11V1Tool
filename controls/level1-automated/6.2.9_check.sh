#!/bin/bash

# Function to check root's PATH integrity
check_root_path_integrity() {
    RPCV="$(sudo env | grep '^PATH' | cut -d= -f2)"
    local output=""

    echo "$RPCV" | grep -q "::" && output+="FAIL: root's path contains an empty directory (::)\n"
    echo "$RPCV" | grep -q ":$" && output+="FAIL: root's path contains a trailing (:)\n"

    for x in $(echo "$RPCV" | tr ":" " "); do
        if [ -d "$x" ]; then
            ls -ldH "$x" | awk '
                $9 == "." {print "FAIL: PATH contains current working directory (.)"}
                $3 != "root" {print "FAIL:", $9, "is not owned by root"}
                substr($1,6,1) != "-" {print "FAIL:", $9, "is group writable"}
                substr($1,9,1) != "-" {print "FAIL:", $9, "is world writable"}
            ' | while read -r line; do
                output+="$line\n"
            done
        else
            output+="FAIL: $x is not a directory\n"
        fi
    done

    if [ -z "$output" ]; then
        echo -e "6.2.9 Ensure root PATH Integrity --> \033[0;32mpassed\033[0m"
    else
        echo -e "6.2.9 Ensure root PATH Integrity --> \e[31mfailed\e[0m\n$output"
    fi
}

# Call the function to check root's PATH integrity
check_root_path_integrity
