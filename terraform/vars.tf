variable "compartment_ocid" {
  type        = string
  description = "Compartment ocid"
}

variable "use_always_free" {
  default     = false
  description = "Checking this will use Always-free Autonomous version"
}

variable "ords_url" {
  type        = string
  default     = ""
  description = "ORDS url"
}

variable "apex_url" {
  type        = string
  default     = ""
  description = "APEX url"
}
