data "oci_objectstorage_namespace" "user_namespace" {
  compartment_id = var.compartment_ocid
}

data "template_file" "index" {
  template = "${file("./html/index.html")}"
  vars = {
    APEX_URL = "${var.apex_url}"
    ORDS_URL = "${var.ords_url}"
  }
}
