provider "aws" {
  region     = "eu-west-1"
  access_key = "AKIAZFON5LYWU5AGICMY"
  secret_key = "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"
}

resource "aws_instance" "web" {
  ami           = "ami-0f0e333655f014f4f"
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}
