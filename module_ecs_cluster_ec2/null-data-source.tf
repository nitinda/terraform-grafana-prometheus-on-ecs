data "null_data_source" "null_resource_override_instance_types" {
  count = "${length(var.override_instance_types)}"

  inputs = "${map(
    "instance_type", trimspace(element(var.override_instance_types, count.index))
  )}"
}
