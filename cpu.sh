#!bin/bash 
# script that calculates cpu usage in percent
# you need to execute cat /proc/stat /tmp/old beforehand

old_idle=$(cat /tmp/old | awk 'NR>1 && NR < 6 {print $5+$6}')
old_active=$(cat /tmp/old | awk 'NR>1 && NR < 6 {print $2+$3+$4+$7+$8+$9+$10}')

new_idle=$(cat /proc/stat | awk 'NR>1 && NR < 6 {print $5+$6}')
new_active=$(cat /proc/stat | awk 'NR>1 && NR < 6 {print $2+$3+$4+$7+$8+$9+$10}')

old_total=$(paste <(echo "$old_idle") <(echo "$old_active") --delimiters ' ' | awk '{print $1+$2}')
new_total=$(paste <(echo "$new_idle") <(echo "$new_active") --delimiters ' ' | awk '{print $1+$2}')

totald=$(paste <(echo "$new_total") <(echo "$old_total") --delimiters ' ' | awk '{print $1-$2}')
idled=$(paste <(echo "$new_idle") <(echo "$old_idle") --delimiters ' ' | awk '{print $1-$2}')

perc=$(paste <(echo "$totald") <(echo "$idled") --delimiters ' ' | awk '{print int((($1 - $2) * 100) / $1)"%"}')
echo $perc

cat /proc/stat > /tmp/old # save the current usage as old values for the next run
