resource "aws_instance" "private_instance" {
  ami                    = "ami-01d21b7be69801c2f"
  instance_type          = var.instance_type
  key_name               = "denis-key-paris"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = "hillel-demo-private-instance"
  }
}

resource "aws_instance" "public_instance" {
  ami                    = "ami-01d21b7be69801c2f"
  instance_type          = var.instance_type
  key_name               = "denis-key-paris"
  subnet_id              = var.puplic_subnet_id
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name = "hillel-demo-public-instance"
  }
}
