#!/bin/bash
# Translate dmesg timestamps to human readable format
# Many lines are copied from https://blog.sleeplessbeastie.eu/2013/10/31/how-to-deal-with-dmesg-timestamps/ . Thanks!

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
tzoffset=$(sed -r 's/.* ([^ ]*) 20..$/\1/' date_stdout)
if ! grep '[0-9]$' <<<"$tzoffset" > /dev/null; then
  tzoffset=$(awk '$1 == "'$tzoffset'" {print gensub(".*UTC ([+-]*[:0-9]+).*","UTC\\1",1);exit}' timezone.txt)
fi
export TZ=$(tr '+-' '-+' <<<$tzoffset)
#echo $TZ
snapshot_date=$(sed -r "s/ [^ ]* 20(..)$/ $tzoffset 20\1/" date_stdout)
#echo $snapshot_date
#exit

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
