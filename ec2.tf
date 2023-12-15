provider "aws" {
  region     = "eu-west-1"
  access_key = "AKIAZFON5LYWU5AGICMY"
  secret_key = "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"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnt[count.index]

  count = 3
  tags = {
    Name = var.namesub[count.index]
  }

}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "web" {
  count = 3
  ami           = "ami-0f0e333655f014f4f"
  instance_type = "t3.micro"
  vpc_security_group_ids = aws_security_group.allow_tls.id
  subnet_id = aws_subnet.main[count.index].id
  tags = {
    Name = var.nameec2[count.index]
  }
}
