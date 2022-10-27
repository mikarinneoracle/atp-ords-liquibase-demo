resource "oci_objectstorage_bucket" "pricing" {
  compartment_id = var.compartment_ocid
  name           = "pricing"
  namespace      = data.oci_objectstorage_namespace.user_namespace.namespace
  access_type    = "ObjectReadWithoutList"
}

resource "oci_objectstorage_object" "index_html" {
  bucket    = oci_objectstorage_bucket.pricing.name
  content   = file("./html/index.html")
  namespace = data.oci_objectstorage_namespace.user_namespace.namespace
  object    = "index.html"
  content_type = "text/html"
}

resource "oci_objectstorage_object" "vue_js" {
  bucket    = oci_objectstorage_bucket.pricing.name
  content   = file("./html/vue.js")
  namespace = data.oci_objectstorage_namespace.user_namespace.namespace
  object    = "vue.js"
  content_type = "text/javascript"
}

resource "oci_objectstorage_object" "pricing_css" {
  bucket    = oci_objectstorage_bucket.pricing.name
  content   = file("./html/pricing.css")
  namespace = data.oci_objectstorage_namespace.user_namespace.namespace
  object    = "pricing.css"
  content_type = "text/css"
}

resource "oci_objectstorage_bucket" "pricing_tf" {
  compartment_id = var.compartment_ocid
  name           = "pricing_tf"
  namespace      = data.oci_objectstorage_namespace.user_namespace.namespace
}

resource "oci_objectstorage_object" "atp_wallet" {
  bucket    = oci_objectstorage_bucket.pricing_tf.name
  content   = resource.oci_database_autonomous_database_wallet.autonomous_database_wallet.content
  namespace = data.oci_objectstorage_namespace.user_namespace.namespace
  object    = "atp_wallet"
}

resource "oci_objectstorage_preauthrequest" "atp_wallet_preauth" {
  access_type  = "ObjectRead"
  bucket       = oci_objectstorage_bucket.pricing_tf.name
  name         = "atp_wallet_preauth"
  namespace    = data.oci_objectstorage_namespace.user_namespace.namespace
  time_expires = timeadd(timestamp(), "30m")
  object = oci_objectstorage_object.atp_wallet.object
}