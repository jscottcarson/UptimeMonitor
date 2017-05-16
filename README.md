# Jenkins-Auto-Failover
This script monitors the Enterprise Jenkins Windows Master uptime and automates failover on loss of connectivity. The script is found on the cron server by assuming the ec2-user with sudo su ec2-user and navigating to /cron-jobs/Jenkins-Auto-AMI/uptime.

Dependencies

1. lastami.txt file output by Jenkins-Auto-AMI repo script in nightly backup in the /cron-jobs/Jenkins-Auto-AMI directory.
2. Expect installed on cron server or server hosting the script.


