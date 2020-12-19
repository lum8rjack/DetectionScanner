FROM ubuntu:18.04

RUN apt-get update -y

# Install clamav, yara and additional dependencies
RUN apt-get install -y clamav clamav-daemon yara git wget

# Delete old clamav logs
RUN rm /var/log/clamav/*.log

# Set working directory to download additional items
WORKDIR /opt/downloads

# Make additional directories
RUN mkdir /opt/allYara && mkdir /opt/allClam

# Download rules from open source repos and move to the allYara folder
RUN git clone https://github.com/fireeye/red_team_tool_countermeasures.git
RUN cp /opt/downloads/red_team_tool_countermeasures/all-yara.yar /opt/allYara/
RUN cp /opt/downloads/red_team_tool_countermeasures/all-clam.ldb /opt/allClam/

RUN git clone https://github.com/Yara-Rules/rules.git
RUN rm /opt/downloads/rules/*index*
RUN for x in $(find /opt/downloads/rules/ | grep .yar); do cp $x /opt/allYara/; done
RUN rm /opt/allYara/Android_* && rm /opt/allYara/domain.yar

# Copy the DetectionScanner.sh file to docker make it executable
COPY DetectionScanner.sh /opt/downloads
RUN chmod +x /opt/downloads/DetectionScanner.sh

# Working directory that files will be mapped to
WORKDIR /opt/documents

# Update clamav signature database
# This is ran last so it should be updated based on the last build date
RUN freshclam

# Run DetectionScanner
CMD /opt/downloads/DetectionScanner.sh
