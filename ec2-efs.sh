$ aws ec2 create-security-group \
--region ca-central-1 \
--group-name efs-walkthrough1-ec2-sg \
--description "Amazon EFS walkthrough 1, SG for EC2 instance" \
--vpc-id vpc-05340cca3af5f0c56 \



$ aws ec2 create-security-group \
--region ca-central-1 \
--group-name efs-walkthrough1-mt-sg \
--description "Amazon EFS walkthrough 1, SG for mount target" \
--vpc-id vpc-05340cca3af5f0c56 \

SG-ID-2-EFS: sg-05c57bc7e3c3a2d74
SG-ID-1-EC2: sg-0813f906b2b6479e3

$ aws ec2 authorize-security-group-ingress \
--group-id sg-0813f906b2b6479e3 \
--protocol tcp \
--port 22 \
--cidr 0.0.0.0/0 \
--region ca-central-1


$ aws ec2 authorize-security-group-ingress \
--group-id sg-05c57bc7e3c3a2d74 \
--protocol tcp \
--port 2049 \
--source-group sg-0813f906b2b6479e3 \
--region ca-central-1

$ aws ec2 run-instances \
--image-id ami-0956b8dc6ddc445ec \
--count 1 \
--instance-type t2.micro \
--associate-public-ip-address \
--key-name my-keypair \
--security-group-ids sg-0813f906b2b6479e3 \
--subnet-id subnet-011ab722912e67192 \
--region ca-central-1 

$ aws efs create-file-system \
--encrypted \
--creation-token FileSystemForWalkthrough1 \
--tags Key=Name,Value=SomeExampleNameValue \
--region ca-central-1 

EFS-ID: fs-055b8f297999c9df7
EC2-ID: i-0db2db69f4c8eb590
SUBNET-ID: subnet-011ab722912e67192

$ aws efs put-lifecycle-configuration \
--file-system-id fs-055b8f297999c9df7 \
--lifecycle-policies TransitionToIA=AFTER_30_DAYS \
--region ca-central-1 

$ aws efs create-mount-target \
--file-system-id fs-055b8f297999c9df7 \
--subnet-id  subnet-011ab722912e67192 \
--security-group sg-05c57bc7e3c3a2d74 \
--region ca-central-1

EFS-DNS:  fs-055b8f297999c9df7.efs.ca-central-1.amazonaws.com
EC2-DNS: 