function level1-automated(){
    for file in controls/level1-automated/*;
        do
        ./$file
    done
}
function level1-manual(){
    for file in controls/level1-manual/*;
        do
        ./$file
    done
}
function level2-automated()
{
    for file in controls/level2-automated/*;
        do
        ./$file
    done
}
function level2-manual(){
    for file in controls/level1-manual/*;
        do
        ./$file
    done
}


function calculate()
{
    
    
    #Calling the function to print the output 
    level1-automated 
    level1-manual
    level2-automated 
    level2-manual

    #writing the scores to caluculate
    (level1-automated 2>&1 | grep -i failed) > level1-automated-failed.txt
    (level1-automated 2>&1 | grep -i passed) > level1-automated-passed.txt
    (level1-manual 2>&1 | grep -i failed) > level1-manual-failed.txt
    (level1-manual 2>&1 | grep -i passed) > level1-manual-passed.txt

    echo "-------------------------------------"
    echo "Recommended and Must Have Controls"
    echo -e "\n"
    #calculating the Level1 Automated Score
    level1automatedpassed=$(cat level1-automated-passed.txt | wc -l)
    echo "Level1-Automated Passed Controls = $level1automatedpassed"
    level1automatedfailed=$(cat level1-automated-failed.txt | wc -l)
    echo "Level1-Automated Failed Controls = $level1automatedfailed"
    level1automatedtotal=$(($level1automatedpassed+$level1automatedfailed))
    echo "Level1-Automated Total Score = $level1automatedtotal"
    passpercentagelevel1automated=$(( (level1automatedpassed * 100) / level1automatedtotal ))
    echo "Level1-Automated Percentage = $passpercentagelevel1automated%"
    

    (level2-automated 2>&1 | grep -i failed) > level2-automated-failed.txt
    (level2-automated 2>&1 | grep -i passed) > level2-automated-passed.txt
    level2automatedpassed=$(cat level2-automated-passed.txt | wc -l)
    echo "Level2-Automated Passed Controls = $level2automatedpassed"
    level2automatedfailed=$(cat level2-automated-failed.txt | wc -l)
    echo "Level2-Automated Failed Controls = $level2automatedfailed"
    level2automatedtotal=$(($level2automatedpassed+$level2automatedfailed))
    echo "Level2-Automated Total Score = $level2automatedtotal"
    passpercentagelevel2automated=$(( (level2automatedpassed * 100) / level2automatedtotal ))
    echo "Level2-Automated Percentage = $passpercentagelevel2automated%"

    echo -e "\n"
    echo "Combined Automated Score"
    echo -e "\n"
    combinedpassed=$(($level1automatedpassed+$level2automatedpassed))
    combinedfailed=$(($level1automatedfailed+$level2automatedfailed))
    combinetotal=$(($level1automatedtotal+$level2automatedtotal))
    combinedpercentage=$(( (combinedpassed * 100) / combinetotal ))

    echo "Combined Passed Controls:$combinedpassed"
    echo "Combined Failed Controls:$combinedfailed"
    echo "Combined Total:$combinetotal"
    echo "Combined Pass Precentage:$combinedpercentage%"

    echo "------------------------"
    echo "Recommended Controls"
    

    #calculating the Level1 Manual Score
    level1manualpassed=$(cat level1-manual-passed.txt | wc -l)
    echo "Level1-Manual Passed Controls = $level1manualpassed"
    level1manualfailed=$(cat level1-manual-failed.txt | wc -l)
    echo "Level1-Manual Failed Controls = $level1manualfailed"
    level1manualtotal=$(($level1manualpassed+$level1manualfailed))
    echo "Level1-Manual Total Score = $(($level1manualpassed+$level1manualfailed))"
    passpercentagelevel1manual=$(( (level1manualpassed * 100) / level1manualtotal ))
    echo "Level1-Manual Percentage = $passpercentagelevel1manual%"
   
    #calculating the Level2 Automated Score
    
    level2manualpassed=$(cat level2-manual-passed.txt | wc -l)
    echo "Level2-Manual Passed Controls = $level2manualpassed"
    level2manualfailed=$(cat level2-manual-failed.txt | wc -l)
    echo "Level2-Manual Failed Controls = $level2manualfailed"
    echo "Level2-Manual Total Score = $(($level2manualpassed+$level2manualfailed))"
    if [ -n "$level2manualtotal" ] && [ "$level2manualtotal" -gt 0 ]; then
    passpercentage=$(( (level2manualpassed * 100) / level2manualtotal ))
    echo "Pass Percentage: $passpercentage%"
    else
        echo "Total number of tests is 0 or not set. Cannot calculate pass percentage."
    fi
}


calculate

