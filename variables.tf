variable "project_name" {
  type        = string
  description = "name of the project"
}

variable "project_env" {
  type        = string
  description = "environment of the project"
}

variable "ami_id" {
  type        = string
  description = "ami id of the instance"
}

variable "instance_type" {
  type        = string
  description = "instance type"
}

variable "region" {
  type        = string
  description = "aws data center region"
}
