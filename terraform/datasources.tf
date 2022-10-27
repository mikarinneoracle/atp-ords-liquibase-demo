data "oci_objectstorage_namespace" "user_namespace" {
  compartment_id = var.compartment_ocid
}
