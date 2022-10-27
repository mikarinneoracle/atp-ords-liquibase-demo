data "oci_objectstorage_namespace" "user_namespace" {
  compartment_id = var.compartment_ocid
}

data "oci_database_autonomous_database_wallet" "autonomous_database_wallet" {
  autonomous_database_id = oci_database_autonomous_database.pricing_autonomous_database.id
  password               = "WelcomeFolks123#!"
  base64_encode_content  = "true"
}
