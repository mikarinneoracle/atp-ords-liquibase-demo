data "oci_objectstorage_namespace" "user_namespace" {
  compartment_id = var.compartment_ocid
}

data "template_file" "index" {
  template = file("./html/index.html")
  vars = {
    URL = var.apex
  }
}

data "template_file" "vue" {
  template = file("./html/vue.js")
  vars = {
    URL = var.url
  }
}