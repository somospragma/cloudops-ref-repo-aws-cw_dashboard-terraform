variable "dashboard_configs" {
  type = list(object({
    functionality = string
    services     = map(bool)
  }))
}


variable "client" {
  type = string
}

variable "environment" {
  type = string
}

variable "project" {
  type = string  
}

variable "application" {
  type = string  
}
