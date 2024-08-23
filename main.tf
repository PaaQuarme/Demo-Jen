
resource "aws_vpc" "Jenkins-Project" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = {
        name = "Jenkins-Project"
        env = "prod"
    }
}

# 2 public subnets
resource "aws_subnet" "Jenkins-pub-sub-1" {
    vpc_id = aws_vpc.Jenkins-Project.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-2a"

    tags = {
        name = "Jenkins-pub-sub-1"
        env = "prod"
    }
}

resource "aws_subnet" "Jenkins-pub-sub-2" {
    vpc_id = aws_vpc.Jenkins-Project.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-2b"

    tags = {
        name = "Jenkins-pub-sub-2"
        env = "prod"
    }
}

# 2 Private subnet
resource "aws_subnet" "Jenkins-priv-sub-1" {
    vpc_id = aws_vpc.Jenkins-Project.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "eu-west-2a"

    tags = {
        name = "Jenkins-priv-sub-1"
        env = "prod"
    }
}

resource "aws_subnet" "Jenkins-priv-sub-2" {
    vpc_id = aws_vpc.Jenkins-Project.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "eu-west-2b"

    tags = {
        name = "Jenkins-priv-sub-2"
        env = "prod"
    }
}

# Public Router
resource "aws_route_table" "Jenkins-pub-router" {
  vpc_id = aws_vpc.Jenkins-Project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Jenkins-igw.id
  }

  tags = {
    name = "Jenkins-pub-router"
    env = "prod"
  }
}

# Subnet Association Public Router
resource "aws_route_table_association" "Public-RT1" {
    subnet_id = aws_subnet.Jenkins-pub-sub-1.id
    route_table_id = aws_route_table.Jenkins-pub-router.id
}

resource "aws_route_table_association" "Public-RT2" {
    subnet_id = aws_subnet.Jenkins-pub-sub-2.id
    route_table_id = aws_route_table.Jenkins-pub-router.id
}

# Create IGW
resource "aws_internet_gateway" "Jenkins-igw" {
  vpc_id = aws_vpc.Jenkins-Project.id

  tags = {
    name = "Jenkins-igw"
    env = "prod"
  }
}



