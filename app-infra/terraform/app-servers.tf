provider "aws" {
  region  = "ap-south-1"
}

variable "app_node_count" {
  default = 2
}

# Create app_node node
resource "aws_instance" "app_node" {
  ami           = "ami-0470e33cd681b2476"
  instance_type = "t2.small"
  count = "${var.app_node_count}"
  key_name      = "sre-test-narayanan"
  iam_instance_profile = "admin-iam-role"
  root_block_device {
    volume_size = "100"
    volume_type = "gp2"
    delete_on_termination = false
  }
  tags = {
    Name       = "infra app_node"
    app        = "app_node"
    terraform  = "yes"
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/ec2.py ../ansible/app_setup.yaml  --private-key /root/.ssh/key.pem"
  }
}

# Add A entry for each node
resource "aws_route53_record" "app_node" {
  count = "${var.app_node_count}"
  zone_id = "Z10192063RYBMG5FN1CY7"
  name = "${format("app-node%02d", count.index + 1)}"
  type = "A"
  ttl = "60"
  records = ["${element(aws_instance.app_node.*.public_ip, count.index)}"]
}
