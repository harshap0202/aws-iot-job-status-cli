[output.webm](https://github.com/harshap0202/aws-iot-job-status-cli/assets/116268106/b7ccb0b5-d6d2-45e5-998d-5a0a1998f345)# AWS IOT Job Status Checker

Objective of this task was to create a script that would find the job execution status from AWS IOT using CLI. Script is provided a **thing-group** name, in the group it lists out all the **things**, and for each thing lists out all the **jobs** and check their status

## Prerequisites :
 - IOT device setup
 - AWS cli
 - linux
 
## Steps :

### 1. Setup AWS CLI
 - Setup AWS Account using command `aws configure`
 - Make sure AWS CLI is installed and configured
 
 ![alt text](images/aws-cli.png)


### 2. Run Script
 - To run the script use command `./iot-check.sh (thing-group-name)`

**Expected Output**

[output.webm](https://github.com/harshap0202/aws-iot-job-status-cli/assets/116268106/9e57e259-82a7-4849-a1c4-6cf5526aa5d0)

![alt text](images/output.png)
