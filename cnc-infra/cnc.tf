provider "aws" {
  region  = "ap-south-1"
}

# Elastic IP for cnc node
resource "aws_eip" "cnc" {
  vpc        = true
  instance   = "${aws_instance.cnc.id}"
  tags = {
    Name       = "infra cnc"
    app        = "cnc"
    terraform  = "yes"
  }
}

# Create cnc node
resource "aws_instance" "cnc" {
  ami           = "ami-0470e33cd681b2476"
  instance_type = "t2.small"
  key_name      = "sre-test-narayanan"
  iam_instance_profile = "admin-iam-role"
  root_block_device {
    volume_size = "100"
    volume_type = "gp2"
    delete_on_termination = false
  }
  tags = {
    Name       = "infra cnc"
    app        = "cnc"
    terraform  = "yes"
  }
}

##Create Route53 hosted zone
resource "aws_route53_zone" "cluster-dns-zone" {
  name    = "demo.infra"
  vpc {
    vpc_id     = "vpc-c66c61af"
    vpc_region = "ap-south-1"
  }
}
