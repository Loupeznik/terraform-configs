terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">4.35"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "test" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "vpc_dz_test_01"
  }
}

resource "aws_subnet" "test" {
  vpc_id                  = aws_vpc.test.id
  cidr_block              = "10.1.3.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "snet_dz_test_01"
  }
}

resource "aws_network_interface" "test" {
  subnet_id   = aws_subnet.test.id
  private_ips = ["10.1.3.37"]

  tags = {
    Name = "nic_dz_test_01"
  }
}

resource "aws_security_group" "test" {
  name   = "sg_dz_test_01"
  vpc_id = aws_vpc.test.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_dz_test_01"
  }
}

resource "aws_network_interface_sg_attachment" "test_attachment" {
  security_group_id    = aws_security_group.test.id
  network_interface_id = aws_network_interface.test.id
}

resource "aws_internet_gateway" "test" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name = "gw_dz_test_01"
  }
}

resource "aws_route_table" "test" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test.id
  }

  tags = {
    Name = "rtb_dz_test_01"
  }
}

resource "aws_route_table_association" "test" {
  subnet_id      = aws_subnet.test.id
  route_table_id = aws_route_table.test.id
}

resource "aws_key_pair" "test" {
  key_name   = "test-key"
  public_key = file("~/.ssh/tf_tests_id_rsa.pub")
}

resource "aws_instance" "test" {
  ami           = "ami-096800910c1b781ba"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.test.key_name

  root_block_device {
    volume_size = 16
    volume_type = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index         = 0
  }

  tags = {
    Name = "aws-ubuntu-01"
  }
}

output "ip" {
  value = aws_instance.test.public_ip
}
