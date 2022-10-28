data "oci_objectstorage_namespace" "user_namespace" {
  compartment_id = var.compartment_ocid
}

data "template_file" "vue" {
  template = "${file("./html/vue.js")}"
  vars = {
    APEX_URL = "${var.apex_url}"
    ORDS_URL = "${var.ords_url}"
  }
}
