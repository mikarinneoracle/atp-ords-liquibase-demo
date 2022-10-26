resource "oci_database_autonomous_database" "pricing_autonomous_database" {
  
  #Required
  admin_password           = "WelcomeFolks123#!"
  compartment_id           = var.compartment_ocid
  cpu_core_count           = 1
  data_storage_size_in_tbs = 1
  db_name                  = "pricing"
  is_free_tier             = var.use_always_free
  db_workload              = "OLTP"
  display_name             = "pricing"
}

output "atp" {
   value = "\"${oci_database_autonomous_database.pricing_autonomous_database.id}\""
}