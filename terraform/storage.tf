resource "oci_objectstorage_bucket" "pricing" {
  compartment_id = var.compartment_ocid
  name           = "pricing"
  namespace      = data.oci_objectstorage_namespace.user_namespace.namespace
  access_type    = "ObjectReadWithoutList"
}

resource "oci_objectstorage_object" "index_html" {
  bucket    = oci_objectstorage_bucket.phonebook_public.name
  content   = file("./html/index.html")
  namespace = data.oci_objectstorage_namespace.user_namespace.namespace
  object    = "index.html"
  content_type = "text/html"
}

resource "oci_objectstorage_object" "vue_js" {
  bucket    = oci_objectstorage_bucket.phonebook_public.name
  content   = file("./html/vue.js")
  namespace = data.oci_objectstorage_namespace.user_namespace.namespace
  object    = "vue.js"
  content_type = "text/javascript"
}

resource "oci_objectstorage_object" "pricing_css" {
  bucket    = oci_objectstorage_bucket.phonebook_public.name
  content   = file("./html/pricing.css")
  namespace = data.oci_objectstorage_namespace.user_namespace.namespace
  object    = "pricing.css"
  content_type = "text/css"
}
