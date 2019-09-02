variable common_tags {
  description = "Resources Tags"
  type        = "map"
}

variable "simplescaling_enabled" {
  description = "description"
}

variable "targettrackingscaling_enabled" {
  description = "description"
}

## Policy parameters
variable "adjustment_type" {
  type        = "string"
  description = "Specifies the scaling adjustment.  Valid values are 'ChangeInCapacity', 'ExactCapacity' or 'PercentChangeInCapacity'."
}

variable "autoscaling_group_name" {
  description = "Name of the ASG to associate the alarm with."
}

variable "cooldown" {
  type        = "string"
  description = "Seconds between auto scaling activities."
}

variable "scaling_adjustment" {
  type        = "string"
  description = "The number of instances involved in a scaling action."
}

variable "autoscaling_policy_name" {
  description = "description"
}