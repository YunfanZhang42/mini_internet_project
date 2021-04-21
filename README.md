# BYOI- Fall 2020

This is a modified version of ETH Zurich's Mini Internet exercise to suit the requirements at Columbia University. Please refer to the [original documentation](https://github.com/nsg-ethz/mini_internet_project) for details on the project.
A strong suggestion is to go through ETH's setup instructions before attempting to run from this repository. 

Additional files:
    - ./CSEE4119-F20/generateAS1000connections.py
    - ./CSEE4119-F20/F-20_Topology
    - ./CSEE4119-F20/*.pdf
    - ./CSEE4119-F20/external_links_config_80.txt
    - ./CSEE4119-F20/AS_config_80.txt
    - ./platform/utils/.bashrc
    - ./platform/utils/copyfile.sh
    - ./platform/utils/killTraceroutes.sh
    - ./platform/utils/sendEmails.gs
    - ./platform/utils/server.py
    - ./platform/utils/updateGlass.sh
    - ./platform/utils/updateMatrix.sh
    
## Fall 2020 Setup

- Number of Students: 80
- Number of ASes in total: 120
- Topology- 10 blocks of 8 student ASes each, sandwiched between 2 TA Tier 1 and 2 TA Stub ASes. Refer to the 2020 Stage B document for further details.
- System: 16 CPUs, 128 Gigs RAM, 500GB Hard Drive
  Suggested: Use 20CPU, 128 Gigs RAM, 300GB HardDrive (about 200GB was used at the end), slightly above couldn't hurt.
- Setup time: ~42 hours, consistent with ETH's paper.
- Approx $$: ~500/month

WARN: DO NOT modify any of the original files intended for the setup when the instance is running. The entire platform runs using shell scripts, which takes as input the above and additional files that were generated and stored during the process.  

## Topology Generation:

1. Topology Diagram template can be found at platform/utils/F20_Topology. This file can be opened on [AppDiagrams](https://app.diagrams.net), a free flow chart maker. 

2. Run generateConnections.py to generate external links config as required. An example is present in the file.

3. Run generateAS1000Connections.py and append the output to config.txt file. This generates the lines corresponding to AS1000's connections.

    Suggestion: Rename AS 1000 to a # less than 250. See section 3.a for further details. 

4. AS_config: Make sure the Tier1 and Stub ASes have "config" in the second columns, whereas student ASes have "NoConfig"

## Sequence of checks/alarms before you run ./setup.sh:

### Before running the setup code:

1. Always better to set up monitoring tools on GCP- required to install GCloud Monitoring tools for memory and RAM Usage when the instance is created. 16CPUs and 128Gigs RAM had a Memory and CPU usage of around 95%  on average. These tools require a restart post installation- something you will not be able to do without destorying any running BYOI instances.

2. Reserve a static IP + domain name.

2. Remember IP ranges are between 1 & 254- ensure to keep your AS# (and IXPs) in the topology within this for ease of setup. You might have to manually modify a lot of it if you exceed this limit. As1000 can be replaced with AS250.

    Eg: Create Link for 1000_LONDrouter (ssh) on bridge- Error: any valid prefix is expected rather than "158.1000.10.1/16" for AS1000 while restarting container & setting up links. The default internal does not support 1000- preferable to use 250 instead.

    The containers use the internal subnet 158.X.0.0/16 for connecting to other components within the AS, and use 157.0.0.X to connect to the host VM for port forwarding purposes.

    AS numbers to avoid:
	- 127 : Private IP- the subnet is used by the system (127.0.0.0)
	- 99 : Measurement VM (99.0.0.0)

3. Modify the DNS server script to read "Router1Router2-ASX" instead of "Router1Router2-groupX" -> Essentially replace all groups by AS.

4. Modify the welcome message from 20XX present under config/welcoming_message.txt

5. Set timezone in your instance as EST. The default for any GCP instance, regardless of the region in which it is present is UTC (as of December 2020). Last refreshed timestamp is a part of the connectivity matrix and looking glass, and an erroneous time zone will cause confusion among the students.

6. There are 2 files to modify before running setup.sh: 
    - AS_config.txt: the master config file that has to be filled out manually. It has six columns: #, type (AS/IXP), Preconfigure as per external_links_config.txt? (Config/NoConfig), router_config, internal_links_config, layer2_hosts_config, layer2_hosts config.
    - external_links_config.txt: generated using generate_connections.py (non-AS1000 links) and generateAS1000links.py (AS1000 links)
    
7. Read the instructions thoroughly on ETH's original release [repository](https://github.com/nsg-ethz/mini_internet_project)

### After running the setup code, before opening up to students:
Unfortunately, the setup is not yet connected to the internet. 

1. Install Python on AS1000 from source from source to run the web server. The other requirements- tcpdump, ping come pre-installed. 
If you don't want to install from scratch, one way would be to clone the docker image of the host, install the required packages, recreate the docker image, and use new image while running setup.py. The docker images associated with each container can be found at mini_internet_project/platform/docker_images
For more instructions on using custom docker images, refer to ETH's [repository](https://github.com/nsg-ethz/mini_internet_project) -> Install the Docker Engine. 

2. Install [screen](https://www.gnu.org/software/screen/), or any other terminal multiplexer. This will help us run the webserver, tcpdump, lookingglass and connectivity matrices in parallel to our other platform processes.

3. Ensure that you have opened ports on the firewall. This is a 2 step process- adding the rules on GCP, and then applying the rules to a particular instant.

4. Connectivity Matrix: run an apache web server that returns the connectivity matrix when a GET request is issued. You can use mini_internet/platform/utils/updateMatrix.sh to retrieve the file from the matrix container to the desired location. This file is a simpler version of upload_matrix.sh.

5. Looking Glass: run an apache web server that returns the configuration of a particular component in the internet. You can use mini_internet/platform/utils/updateglass.sh to retrieve the files. This is a much simpler version of upload_looking_glass.sh. 

6. Extract all the passwords from mini_internet/platform/groups/ssh_passwords.txt and mini_internet/platform/groups/ssh_measurement.txt

7. A .gscript template is present in mini_internet/platform/utils/sendEmails.gscript to send emails based off an excel sheet. This has a template for both the initial and preliminary stage announcements.

### After student release:

1. Stage C Web Server: mini_internet/platform/utils/server.py runs a python server that returns a template message to the student while logging their request details. This log is later used to evaluate this section of the assignment.
   You might want to run this server in a separate terminal multiplexed session.

2. BashDownloadClient: mini_internet/platform/utils/.bashrc: The function in this bash file can be used to fetch a file within the mini_internet from the webserver. For further explanation, refer to Stage C document of Fall 2020.
   Additionally, mini_internet/platform/utils/copyfile.sh can be used to copy a file into every AS (modify as per file and topology requirements).

## General notes/Knowledge transfer

1. Restarting a container: run the following from mini_internet/platform folder:
    ``` ./groups/restart_container.sh [AS#]```
    Once done, don't forget to enable port forwarding for that particular AS again, as given below

2. Port Forwarding for AS X mapping port 2000+X to the container:
    ``` sudo ssh -i groups/id_rsa -o "StrictHostKeyChecking no" -f -N -L 0.0.0.0:2000+X:157.0.0.X+10:22 root@157.0.0.X+10 ```

3. configure_as.sh can be used to configure any VM according to the specs present in the external_links_config.txt.

## Bugs/Issues faced:
1. fork: retry: Resource temporarily unavailable- from inside one of the ssh_containers - due to high # of processes started by the students (most likely the # of simlutaneous or incorrectly terminated ssh sessions).
This can happen primarily because of 2 reasons:
   - #simultaneous traceroutes launched: The longest traceroute is about 10 hops (including both intra and inter AS connections). This means 10 pings are launched every traceroute- results in 10 processes being created within the container. Given that the management VM is shared by all the students, multiple students starting traceroutes simlutaneously can cause the container to hang. Make sure you always have a screen running with the terminal of this container in case you have to manually kill any processes.
    Hot fix: mini_internet/platform/utils/killtraceroutes.sh runs when the total process count exceeds a given number (100 in this case)
    
    - Incorrect termination of SSH sessions: Incorrect termination leads to stale ssh sessions in the background. 
	Solution: These have to be cleared manually- differentiating between the ssh session holding the container to the host system vs student sessions is not straightforward. Regularly killing any stale ssh sessions is necessary. An advisory to students to not use multiple connections to the VM at the same time will also help.
    
2. Setup is not restart friendly neither at the container level nor the project level- since each docker container represents only one service, restarting FRR routing from within the container is not possible. One has to restart the container as a whole- this means that the container's should be built from scratch and configured again. Container restart time: ~6mins per AS (ie 6 minutes for ASX to connect to ASY)

3. No restore functionality

4. Restarting AS1000- takes about 10-15 hours given the number of connections it has to form. 

## Potential Improvements:

1. Looking Glass currently uses a round-robin method to fetch the data from all devices in the topology. This results in the glass taking a long time to reflect any changes in the configuration. 
   Solution: Fetch the file from the container on request- write a servier that does a retrives the corresponding file present in the device's home directory when a GET request is issued by a user.

2. Install Python+other packages on all hosts- this can help create other methods of testing/questioning (example running Project 1: a video proxy by hosting content on our web server available in AS1000)
   Discuss with the professor for this particular implementation- ensure that the list of *allowed* packages for Project 1, update DockerFile associated with the host and create a new image.

3. See if the connectivity matrix can be sped up (not sure how to go about it). The current implementation details can be found in the original repository.
