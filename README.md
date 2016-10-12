# terraform-exercise

This terraform template will create the following

- VPC;
- Internet Gateway;
- Two Private and two public Subnets;	
- Public Route Table and Public Route;
- Private Route Table and Private Route;
- NAT gateway;
- Two autoscaled EC2 instances distributed across Availability Zones;
- S3 bucket;
- Two Elastic IP (attached to each instance);
- Custom security group attached to every instance (any which you think may be needed);
- EBS volumes of any size attached as root device (of type magnetic);
- Elastic Load Balancer for instances created (ELB port 80 to instance port 80);
- Install Apache on both servers via User Data and customize its welcome page on each server to contain hostname. Then check and ensure ELB works as expected.
