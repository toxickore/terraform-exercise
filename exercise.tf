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
	cidr_block = "10.0.1.0/24"

	tags {
		Name = "example_priv01_subnet"
	}
}

resource "aws_subnet" "example_priv02_subnet" {
	vpc_id = "${aws_vpc.example_vpc.id}"
	cidr_block = "10.0.2.0/24"

	tags {
		Name = "example_priv02_subnet"
	}
}

resource "aws_subnet" "example_pub01_subnet" {
	vpc_id = "${aws_vpc.example_vpc.id}"
	cidr_block = "10.0.3.0/24"

	tags {
		Name = "example_pub01_subnet"
	}
}

resource "aws_subnet" "example_pub02_subnet" {
	vpc_id = "${aws_vpc.example_vpc.id}"
	cidr_block = "10.0.4.0/24"

	tags {
		Name = "example_pub02_subnet"
	}
}

resource "aws_route_table" "example_pub_rt" {
	vpc_id = "${aws_vpc.example_vpc.id}"
	route {
		cidr_block = "10.0.1.0//24"
		gateway_id = "${aws_internet_gateway.example_igw.id}"
	}
	
	tags {
		Name = "example_pub_rt"
	}
}
