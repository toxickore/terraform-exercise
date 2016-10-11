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
