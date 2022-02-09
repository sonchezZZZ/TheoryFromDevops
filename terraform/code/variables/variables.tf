variable "region" {
    description = "Enter region"
    default     = "us-east-1"
}


variable "instance_type" {
  description = "Enter type"
  default     = "t2.micro"
}

variable "allow_ports" {
  type    = list                 // string, list, map, bool
  default = ["80","443"]
}

variable "detail_monitoring" {
  type = bool
  default = true
}

variable "common_tags" {
  type = map
  description = " tags fro all resources"
  default = {
    Owner = "Sofiia Cherednychenko"
    Project = "Sonchezz_Environment"
    Environment = "Development"
  }
}
