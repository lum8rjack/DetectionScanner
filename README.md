# DetectionScanner
DetectionScanner was created to have a simple and fast way to scan Red Team payloads before using them in a campaign. Previously, I would build the payload and then copy it to a virtual machine and manually scan each file with the installed AV product. That step may still be needed if you want to scan against a specific AV product, but this tool should provide a quick first check. If DetectionScanner flags the file as malicious then it might be worth making additional changes to the payload before doing more manual checks in a virtual machine. DetectionScanner could also be added to the CICD pipeline when building payloads.

## Install and Build
Getting setup is as easy as cloning the repository and building the image.
1. git clone https://github.com/lum8rjack/DetectionScanner
2. cd DetectionScanner
3. ./build.sh

## Scan
Once the Docker image is built, it is easy to scan your files and output the results to a text file.
1. cd to the directory containing the file(s) that will be scanned
2. docker run -it --rm -v $(pwd):/opt/documents/ detectionscanner
	* DetectionScanner will first update the ClamAv database if it has been more than 1 day since the last check
	* DetectionScanner will then scan the file(s) and save the results to DetectionScanner_results_DATE.txt

## Improvements
1. Add additional Yara rules
	* https://github.com/InQuest/awesome-yara
2. Update the results to be easier to read

## Acknowledgments
This project was build using the following projects:
* [ClamAv](https://www.clamav.net)
	* [FireEye Red Team Tool Countermeasures signatures](https://github.com/fireeye/red_team_tool_countermeasures)
* [Yara](https://virustotal.github.io/yara/)
	* [FireEye Red Team Tool Countermeasures rules](https://github.com/fireeye/red_team_tool_countermeasures)
	* [Yara-Rules](https://github.com/Yara-Rules/rules)


