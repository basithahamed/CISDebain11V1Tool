
declare -i passedscore=0
declare -i totalscore=0

call_python_function() {
    local arg1=$1
    # sh $arg1  
    # temp=$($arg1)
    # echo $temp
    local script_dir="$(dirname "$0")"  # Get the directory of the Bash script
    local result=$(python -c "import sys; sys.path.insert(0, '$script_dir'); from test import find; print(find('$arg1'))")
    
    totalscore=$totalscore+1
    echo $result
    # echo "result:$result"
    # if [ "$result" -eq 1 ]; then
        
    #     passedscore=$passedscore+1
    # fi  

}

# Call the function and pass arguments
for file in controls/level1-automated/*;
do
    # Escape double quotes in $file using printf
    escaped_file=$(printf '%q' "$file")
    call_python_function "$escaped_file"
done

echo "Passed score:$passedscore"
echo "total score:$totalscore"
