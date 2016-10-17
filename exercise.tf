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
		gateway_id = "${aws_nat_gateway.example_nat_gw.id}"
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

resource "aws_nat_gateway" "example_nat_gw" {
	allocation_id = "eipalloc-207c2e1f"
	subnet_id = "${aws_subnet.example_pub01_subnet.id}"
}

resource "aws_launch_configuration" "example_lc" {
	name = "example_lc"
	image_id = "ami-c481fad3"
	instance_type = "t2.micro"
	security_groups = ["example_secgroup01"]
	ebs_block_device = {
		device_name = "/dev/sdk"
		volume_size = 1
		volume_type = "standard"
		delete_on_termination = true
	}
	user_data = "yum -y install httpd && service httpd start"
	key_name = "emerson"
}

resource "aws_autoscaling_group" "example_asg01" {
	availability_zones = ["us-east-1a","us-east-1b"]
	name = "example_asg01"
	max_size = 1
	min_size = 1
	launch_configuration = "${aws_launch_configuration.example_lc.name}"
	load_balancers = ["${aws_elb.example_elb.id}"]
}

resource "aws_autoscaling_group" "example_asg02" {
	availability_zones = ["us-east-1c","us-east-1e"]
	name = "example_asg02"
	max_size = 1
	min_size = 1
	launch_configuration = "${aws_launch_configuration.example_lc.name}"
	load_balancers = ["${aws_elb.example_elb.id}"]
}

resource "aws_s3_bucket" "example_bucket" {
	bucket = "example_terraform_s3_bucket"
	acl = "private"

	tags {
		Name = "example_bucket"
	}
}

/* EIP commented, no nat Instance on this terraform script
resource "aws_eip" "example_eip01" {
	instance = "${aws_instance.example_nat_instance.id}"
	vpc = true
}

resource "aws_eip" "example_eip02" {
	instance = "${aws_instance.example_nat_instance.id}"
	vpc = true
}
*/

resource "aws_security_group" "example_secgroup01" {
	name = "example_secgroup01"
	description = "Very basic security group to allow ssh connections and web traffic on http/https"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"	
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	vpc_id = "${aws_vpc.example_vpc.id}"

}

resource "aws_elb" "example_elb" {
	name = "example-elb"
	availability_zones = ["us-east-1a","us-east-1b","us-east-1c","us-east-1e"]

	listener {
		instance_port = 80
		instance_protocol = "http"
		lb_port = 80
		lb_protocol = "http"
	}

	health_check {
		healthy_threshold = 2
		unhealthy_threshold = 2
		timeout = 3
		target = "HTTP:80/"
		interval = 30
	}

	tags {
		Name = "example-elb"
	}
}
