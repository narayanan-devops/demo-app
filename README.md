<h1 align="center">Demo Project</h1>

<!-- TABLE OF CONTENTS -->
# Table of Contents

* [About the Project](#about-the-project)
  * [Built With](#built-with)
  * [Goal](#goal)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Demo](#demo)


<!-- ABOUT THE PROJECT -->
# About The Project

Demo project to showcase the sample Onboarding of a go-lang project in AWS infra using automation tools.

### Built With

* []()Ansible for configuration management
* []()Terraform for provisioning
* []()Github for maintaining the source control

## Goal
a) Launch 3 separate Linux nodes using terraform
```bash
2 x application nodes
1 x web node
```
b) Deploy the sample golang application to the application nodes using local-exec terraform provisioner

c) Install NGINX on the web node and balance requests in a round-robin fashion


## Design considerations
1. Ansible inventory should be dynamic and selection of host should be tag based during the run time,  so that we can add and remove servers seamlessly via terraform
2. Provisioning of respective nodes(terraform apply) should also do bootstrapping of dependencies and app deployment using ansible.
3. Nginx routing must use backend server private DNS endpoints so that traffic between Web and the app servers will be private and wont incur cost(considering the infra is on AWS).


<!-- GETTING STARTED -->
# Getting started
### Prerequisites

1. Setup the AWS access & secret key in your environment.
```sh
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx
export AWS_DEFAULT_REGION=ap-south-1
```
2. Considering the project is running on **Amazon Linux**, need to setup the ansible using below command
```sh
sudo pip install ansible
```

### Installation
 
1. Clone the repo
```sh
git clone https://github.com/narayanan-devops/demo-app.git
```
2. Launch the CNC node and setup Route53 zones
Incase if we wish to move apps to internal private subnet, launch this CNC server(Command and control server) so that we can access all the private instances from this instances.
``` sh
cd demo-app/cnc-infra/terraform 
terraform plan -out=tf.out 
terraform apply "tf,out"
```
3.   Launch the app nodes 
```
cd demo-app/app-infra/terraform
terraform plan -out=tf.out
terraform apply "tf.out"
```
4. Launch the web server
```sh
cd demo-app/web-infra/terraform
terraform plan -out=tf.out
terraform apply "tf.out"
```

# Demo



[![asciicast](https://asciinema.org/a/onZWCW6DZVmoERruba6ggpfGO.svg)](https://asciinema.org/a/onZWCW6DZVmoERruba6ggpfGO)
