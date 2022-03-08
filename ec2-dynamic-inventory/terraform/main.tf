resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  
  key_name   = "mykey"
  public_key = tls_private_key.example.public_key_openssh
  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.example.private_key_pem}' > ./myKey.pem"
  }
}

resource "aws_instance" "example" {
  count = 5  
  ami           = "ami-076754bea03bde973"
  key_name      = aws_key_pair.generated_key.key_name
  instance_type = "t2.micro"
  tags = {
      "Environment" = "prod"
  }
}

