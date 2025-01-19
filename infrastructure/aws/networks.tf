resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(local.common_tags,
    {
      Name = "shaswatpoc-vpc"
  })
}

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr1
  availability_zone = "us-east-1a"
  tags = merge(local.common_tags,
    {
      Name = "shaswatpoc-public_subnet1"
  })

}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr2
  availability_zone = "us-east-1b"
  tags = merge(local.common_tags,
    {
      Name = "shaswatpoc-public_subnet2"
  })

}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr1
  availability_zone = "us-east-1b"
  tags = merge(local.common_tags,
    {
      Name = "shaswatpoc-private_subnet1"
  })

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags,
    {
      Name = "shaswatpoc-igw"
  })
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = local.common_tags
}

resource "aws_route_table_association" "route_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "route_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.route.id
}

resource "aws_security_group" "shaswat_sg" {
  name        = format("%s-sg", local.service_name)
  description = "Security group for ECS task"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["100.64.0.0/16"]
    description = "VPC services"
  }

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = [var.public_ip_allowed]
    description = "Allow requsts from private subnet CIDR"
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = [var.public_ip_allowed]
    description = "Allow requsts from private subnet CIDR"
  }

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    self        = true
    description = "Allow incoming requests in port 20000 to register with Consul server"
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    self        = true
    description = "Allow incoming requests in port 20000 to register with Consul server"
  }
}

resource "aws_security_group_rule" "shaswat_sg_rule" {
  description       = "Allow Egress traffic for any"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.shaswat_sg.id
}