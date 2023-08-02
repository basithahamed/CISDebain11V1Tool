
import os
import subprocess
import sys


def find(a):
    out=subprocess.getoutput(a)
    # print("someeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee",outstat)
    # if(outstat):
        # print(out)
    # out=out.strip().split('\n')[0]
    # f = open("result.txt", "a")
    # f.write("\n"+out)    
    # f.close()
    print(out)
    
    if "--> passed" in out:
        return 1
    else:
        return 0

print(find('controls/level1-automated/1.1.1.1_check.sh'))

# print(find(input("Enter the control name:")))
