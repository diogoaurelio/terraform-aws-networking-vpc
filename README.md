AWS Module to setup AWS VPC
====================================

# Intro

This module provides a template for deploying via terraform a VPC and other typical related beaurocracies.
A good starting point would be having a look at [AWS configuration scenario](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Scenario2.html), very similar to what is being deployed in the current setup.

Using this module will deploy the following AWS resources:

- Public subnet - useful for hosts who face the internet, such as jumphost/bastion
- A custom route table associated with the public subnet - this route table contains an entry that enables instances in the subnet to communicate with other instances in the VPC over IPv4, and an entry that enables instances in the subnet to communicate directly with the Internet over IPv4
- Private subnet - useful for static resources which do not change frequently, such as RDS instances
- Ephemeral private subnets - useful for ephemeral hosts, such as instances deployed in ASG
- A route table associated with the private subnet. The route table contains an entry that enables instances in the subnet to communicate with other instances in the VPC over IPv4, and an entry that enables instances in the subnet to communicate with the Internet through the NAT gateway over IPv4
- An Internet gateway to connect the VPC to the Internet and other AWS services
- NAT gateway with its own Elastic IP (v4) address, useful for instances inside private subnets to send requests to the internet (typically software updates)

# Setup locally

- Before you can run hooks, you need to have the [pre-commit installed in your machine](https://pre-commit.com/#install).
- Run [pre-commit install](https://pre-commit.com/#usage) to setup locally hook for terraform code cleanup.


