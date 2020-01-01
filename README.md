# timezone_abbrev

Scraped text from https://www.timeanddate.com/time/zones/ and some bash one-liners and a script.

## Usage:

```bash
$ cd ~/Cloudera/Diagnostic_Bundle/hosts/xxxxx/
$ ./dmesgtime.sh
```

## dmesgtime.sh:

Converts time offset in dmesg output to local human readable time. Includes some one-liners. Looks up timezone.txt file.

## timezone.txt:

Courtesy of https://www.timeanddate.com/time/zones/. This is just a snapshot of the said page.
