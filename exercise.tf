resource "aws_vpc" "example_vpc" {
	cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "example_igw" {
	vpc_id = "${aws_vpc.example_vpc.id}"

	tags {
		Name = "example_igw"
	}
}

resource "aws_subnet" "example_priv01_subnet" {
	vpc_id = "${aws_vpc.example_vpc.id}"
	availability_zone = "us-east-1a"
	cidr_block = "10.0.1.0/24"

	tags {
		Name = "example_priv01_subnet"
	}
}

resource "aws_subnet" "example_priv02_subnet" {
	vpc_id = "${aws_vpc.example_vpc.id}"
	availability_zone = "us-east-1b"
	cidr_block = "10.0.2.0/24"

	tags {
		Name = "example_priv02_subnet"
	}
}

resource "aws_subnet" "example_pub01_subnet" {
	vpc_id = "${aws_vpc.example_vpc.id}"
	availability_zone = "us-east-1c"
	cidr_block = "10.0.3.0/24"

	tags {
		Name = "example_pub01_subnet"
	}
}

resource "aws_subnet" "example_pub02_subnet" {
	vpc_id = "${aws_vpc.example_vpc.id}"
	availability_zone = "us-east-1e"
	cidr_block = "10.0.4.0/24"

	tags {
		Name = "example_pub02_subnet"
	}
}

resource "aws_route_table" "example_priv_route_table" {
	vpc_id = "${aws_vpc.example_vpc.id}"
	route {
		cidr_block = "0.0.0.0/16"
		gateway_id = "${aws_internet_gateway.example_igw.id}"
}
	
	tags {
		Name = "example_priv_route_table"
	}
}

resource "aws_route_table" "example_pub_route_table" {
	vpc_id = "${aws_vpc.example_vpc.id}"
	route {
		cidr_block = "0.0.0.0/24"
		gateway_id = "${aws_internet_gateway.example_igw.id}"
	}
	
	tags {
		Name = "example_pub_route_table"
	}
}

resource "aws_route" "example_priv_route" {
	route_table_id = "${aws_route_table.example_priv_route_table.id}"
	destination_cidr_block = "0.0.0.0/24"
	gateway_id = "${aws_internet_gateway.example_igw.id}"
}

resource "aws_route" "example_pub_route" {
	route_table_id = "${aws_route_table.example_pub_route_table.id}"
	destination_cidr_block = "0.0.0.0/16"
	gateway_id = "${aws_internet_gateway.example_igw.id}"
}

resource "aws_instance" "example_nat_instance" {
	ami = "ami-c481fad3"
	instance_type = "t2.micro"
	tags {
		Name = "example_nat_instance"
	}
}

/*
resource "aws_nat_gateway" "example_nat_gw" {
	allocation_id = "${aws_eip.nat.id}"
	
}*/
