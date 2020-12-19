#!/bin/bash

NOW=$(date +"%m-%d-%y")
LOGFILE=DetectionScanner_results_$NOW.txt
LOGFILEPATH=/opt/documents/$LOGFILE

# Update ClamAv database if it has been 1 day or more since the database was last updated
echo "[+] Checking if ClamAv needs updated"
for x in $(find /var/lib/clamav/ -type f -mtime +1 | grep daily); do echo "[!] Updating ClamAv signatures"; echo ; freshclam --no-warnings; echo ; echo [+] Done updating ClamAv; done

# Run ClamAv check against main signatures
echo "[+] Scanning files against ClamAv signatures"
echo 
clamscan --log=/tmp/clamscan_output.txt --remove=no --recursive=yes /opt/documents/
echo

# Run ClamAv check against directory containing additional signatures
echo "[+] Scanning files against ClamAv custom signatures"
echo 
clamscan --log=/tmp/clamscan_output_all.txt --remove=no --recursive=yes --database=/opt/allClam/ /opt/documents/
echo

# Run yara checks
echo "[+] Scanning files against Yara rules"
echo
yara --no-warnings -r /opt/allYara/* /opt/documents | tee /tmp/yara_output.txt
echo

# Save output to a results file
echo "DetectionScanner scanned dated: $NOW" > $LOGFILEPATH
echo >> $LOGFILEPATH

echo "ClamAv version" >> $LOGFILEPATH
clamscan --version >> $LOGFILEPATH
echo >> $LOGFILEPATH
echo >> $LOGFILEPATH

echo "ClamAv results from main database signatures" >> $LOGFILEPATH
cat /tmp/clamscan_output.txt >> $LOGFILEPATH
echo "-------------------------------------------------------------------------------" >> $LOGFILEPATH
echo "" >> $LOGFILEPATH

echo "ClamAv results from custom database signatures" >> $LOGFILEPATH
cat /tmp/clamscan_output_all.txt >> $LOGFILEPATH
echo "-------------------------------------------------------------------------------" >> $LOGFILEPATH
echo "" >> $LOGFILEPATH

echo "Yara results" >> $LOGFILEPATH
echo "" >> $LOGFILEPATH
echo "-------------------------------------------------------------------------------" >> $LOGFILEPATH
echo "" >> $LOGFILEPATH
cat /tmp/yara_output.txt >> $LOGFILEPATH
echo "-------------------------------------------------------------------------------" >> $LOGFILEPATH
echo "" >> $LOGFILEPATH

chmod 666 $LOGFILEPATH

echo "[+] Overview of all the checks saved to: $LOGFILE"

