### General Variables ###
### EC2 Values ###
variable "instance_type" {
  type        = string
  description = "Define the EC2 Instance type for the ecs cluster"
  default     = "t2.micro"
}

### ECS ###
variable "container_image" {
  type        = string
  description = "Define what docker image will be deployed to the ECS task"
  default     = "nginx"
}

variable "repository_url" {
  type        = string
  description = "Define repository name"
  default     = "915717527289.dkr.ecr.us-east-1.amazonaws.com/mydocker"
}