#!/bin/bash
/usr/bin/aws aws ec2 run-instances \
    --image-id ami-0fcc78c828f981df2 \
    --count 1 \
    --instance-type t3.micro \
    --security-group-ids sg-02efeff1df99019a6 \
    --subnet-id subnet-02a2478621297b8f6 \
    --block-device-mappings "[{\"DeviceName\":\"/dev/sdf\",\"Ebs\":{\"VolumeSize\":30,\"DeleteOnTermination\":false}}]" \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Frontend}]'