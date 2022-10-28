variable "compartment_ocid" {
  type        = string
  description = "Compartment ocid"
}

variable "use_always_free" {
  default     = false
  description = "Checking this will use Always-free Autonomous version"
}
