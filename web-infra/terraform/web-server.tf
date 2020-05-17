provider "aws" {
  region  = "ap-south-1"
}

variable "web_node_count" {
  default = 1
}

# Create web_node node
resource "aws_instance" "web_node" {
  ami           = "ami-0470e33cd681b2476"
  instance_type = "t2.small"
  count = "${var.web_node_count}"
  key_name      = "sre-test-narayanan"
  iam_instance_profile = "admin-iam-role"
  root_block_device {
    volume_size = "100"
    volume_type = "gp2"
    delete_on_termination = false
  }
  tags = {
    Name       = "infra web_node"
    app        = "web_node"
    terraform  = "yes"
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ../ansible/ec2.py ../ansible/setup-nginx.yaml  --private-key /root/.ssh/key.pem" 
  }
}

# Add A entry for each node
resource "aws_route53_record" "web_node" {
  count = "${var.web_node_count}"
  zone_id = "Z10192063RYBMG5FN1CY7"
  name = "${format("web-node%02d", count.index + 1)}"
  type = "A"
  ttl = "60"
  records = ["${element(aws_instance.web_node.*.public_ip, count.index)}"]
}
