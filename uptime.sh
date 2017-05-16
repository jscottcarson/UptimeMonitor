#!/bin/bash

# check for exit code from Jenkins master
nc -vz 10.12.1.6 445 &> /dev/null

# If exit code is 0 do nothing
if [ $? -eq 0 ]
then
  exit 0
else

#If exit code is not 0 terminate the master
aws ec2 stop-instances --region us-west-2 --instance-ids i-067045a6f81cd37e2

# Spin up new instance from last successful AMI of the master and output the new instance ID to variable
instance_id=$(aws ec2 run-instances --region us-west-2 --key ec2-test --instance-type m3.xlarge --image-id `cat /home/ec2-user/cron-jobs/Jenkins-Auto-AMI/lastami.txt`  --se$
echo Newinstance_id=$instance_id

echo $instance_id > instanceid

# Pause while the new instance is in a pending state
while state=$(aws ec2 describe-instances --region us-west-2 --instance-ids $instance_id --output text --query 'Reservations[*].Instances[*].State.Name'); test "$state" = "p$
  sleep 1; echo -n '.'
done;

echo Get private ip of new instance to retrieve hostname with

aws ec2 describe-instances --instance-ids $instance_id --region us-west-2 | grep "PrivateIpAddress" | head -1 > hostname.txt

sed -i 's/.*://' hostname.txt
tr -d \" < hostname.txt > host2
rm -rf hostname.txt
tr -d \, < host2 > host3
rm -rf host2
sed -i 's/^[ \t]*//' host3
mv host3 hostname.txt
cat hostname.txt

echo Get Hostname using retrieved private IP
host `cat hostname.txt` | awk '{print $NF}'| sed "s/\.$//" > adhostname.txt

# Set variable and call expect script that executes DNS failover.
var=`cat adhostname.txt`
echo $var
expect dns.exp $var
 exit 1

# Run reset script the reset the instance ID and private IP to reset the failover process
bash reset.sh
fi
