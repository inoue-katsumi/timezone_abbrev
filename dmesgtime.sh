#!/bin/bash
# Translate dmesg timestamps to human readable format

# desired date format
date_format="%a %b %d %T %Y"

# uptime in seconds
uptime=$(sed -nr 's/^.*up ([0-9]+) days, +([0-9]+):([0-9]+).*$/\1*24*60*60+\2*60*60+\3*60/p' uptime_cmd_stdout|bc)
#echo $uptime
#exit
#uptime=$(cut -d " " -f 1 /proc/uptime)

#tzoffset=awk -F'\t' '$1 == "'$(sed -r 's/.* ([A-Z]{2,4}) 20..**/\1/' date_stdout)'" {print $NF}' ~/timezone.tsv | tr -d ' '
#echo $tzoffset
#exit
#tzoffset=$(awk -F'\t' '$1 == "'$(sed -r 's/.* ([A-Z]{2,4}) 20..**/\1/' date_stdout)'" {print $NF}' ~/timezone.tsv | tr -d ' ')
tzoffset=$(awk '$1 == "'$(sed -r 's/.* ([A-Z]{2,4}) 20..**/\1/' date_stdout)'" {print gensub(".*UTC ([+-]*[:0-9]+).*","UTC\\1",1);exit}' timezone.txt)
export TZ=$(tr '+-' '-+' <<<$tzoffset)
snapshot_date=$(sed -r "s/ [A-Z]{2,4} 20/ $tzoffset 20/" date_stdout)

# run only if timestamps are enabled
#if [ "Y" = "$(cat /sys/module/printk/parameters/time)" ]; then
#  dmesg | sed "s/^\[[ ]*\?\([0-9.]*\)\] \(.*\)/\\1 \\2/" | while read timestamp message; do
  sed -n "s/^\[[ ]*\?\([0-9.]*\)\] \(.*\)/\\1 \\2/p" dmesg_stdout | while read timestamp message; do
#    printf "[%s] %s\n" "$(date --date "now - $uptime seconds + $timestamp seconds" +"${date_format}")" "$message"
    printf "[%s] %s\n" "$(date --date "$snapshot_date - $uptime seconds + $timestamp seconds" +"${date_format}")" "$message"
  done
#else
#  echo "Timestamps are disabled (/sys/module/printk/parameters/time)"
#fi
