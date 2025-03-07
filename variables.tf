variable "vpc_name" {
  description = "(Required) The name of the VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "(Optional) A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "cidr_block" {
  description = "(Required) The CIDR block for the VPC. Must be /16"
  type        = string

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/16$", var.cidr_block))  # With regex we validate the CIDR block is valid and /16
    error_message = "The CIDR block must be a valid /16 range."
  }
}

variable "multi_az" {
  description = "(Optional) A boolean flag to control if the VPC is multi-AZ"
  type        = bool
  default     = false
}

variable "multi_nat" {
  description = "(Optional) A boolean flag to control if the VPC is multi-NAT"
  type        = bool
  default     = false

  validation {
    condition     = var.multi_az || !var.multi_nat  # We validate based on multi az because not make sense have multi nat in single az
    error_message = "multi_nat can be true only if is_multi_az is true."
  }
}