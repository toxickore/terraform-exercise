resource "aws_vpc" "example" {
	cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
	vpc_id = "${aws_vpc.example.id}"

	tags {
		Name = "main"
	}
}
