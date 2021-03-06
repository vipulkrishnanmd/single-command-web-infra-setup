data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

resource "aws_instance" "jenkins-instance_new" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.medium"
  key_name        = aws_key_pair.common_key.key_name
  vpc_security_group_ids = [aws_security_group.sg_common.id]
  user_data = data.template_file.jenkins_setup.rendered

  associate_public_ip_address = true
  tags = {
    Name = "Jenkins-Instance_new"
  }
}

data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "server_new" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.common_key.key_name
  vpc_security_group_ids = [aws_security_group.sg_common.id]
  user_data = file("server_setup.sh")

  associate_public_ip_address = true
  tags = {
    Name = "webserver_new"
  }
}