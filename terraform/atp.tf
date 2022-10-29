resource "oci_database_autonomous_database" "pricing_autonomous_database" {
  admin_password           = "WelcomeFolks123#!"
  compartment_id           = var.compartment_ocid
  cpu_core_count           = 1
  data_storage_size_in_tbs = 1
  db_name                  = "pricing"
  is_free_tier             = var.use_always_free
  db_workload              = "OLTP"
  display_name             = "pricing"
}

resource "oci_database_autonomous_database_wallet" "autonomous_database_wallet" {
  autonomous_database_id = oci_database_autonomous_database.pricing_autonomous_database.id
  password               = "WelcomeFolks123#!"
  base64_encode_content  = "true"
  provisioner "local-exec" {
    command = "sh script.sh ${oci_database_autonomous_database_wallet.autonomous_database_wallet.content}"
  }
}

output "atp" {
   value = "\"${oci_database_autonomous_database.pricing_autonomous_database.id}\""
}