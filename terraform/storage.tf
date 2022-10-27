resource "oci_objectstorage_bucket" "pricing" {
  compartment_id = var.compartment_ocid
  name           = "pricing"
  namespace      = data.oci_objectstorage_namespace.user_namespace.namespace
  access_type    = "ObjectReadWithoutList"
}

resource "oci_objectstorage_object" "index_html" {
  bucket    = oci_objectstorage_bucket.pricing.name
  content   = templatefile("./html/index.html", {URL = "${apex}"})
  namespace = data.oci_objectstorage_namespace.user_namespace.namespace
  object    = "index.html"
  content_type = "text/html"
  depends_on = [oci_database_autonomous_database_wallet.autonomous_database_wallet]
}

resource "oci_objectstorage_object" "vue_js" {
  bucket    = oci_objectstorage_bucket.pricing.name
  content   = templatefile("./html/vue.js", {URL = "${url}"})
  namespace = data.oci_objectstorage_namespace.user_namespace.namespace
  object    = "vue.js"
  content_type = "text/javascript"
  depends_on = [oci_database_autonomous_database_wallet.autonomous_database_wallet]
}

resource "oci_objectstorage_object" "pricing_css" {
  bucket    = oci_objectstorage_bucket.pricing.name
  content   = file("./html/pricing.css")
  namespace = data.oci_objectstorage_namespace.user_namespace.namespace
  object    = "pricing.css"
  content_type = "text/css"
  depends_on = [oci_database_autonomous_database_wallet.autonomous_database_wallet]
}
