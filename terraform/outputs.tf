output "application_url_in_bucket" {
  value = "http://objectstorage.${oci_objectstorage_object.index_html.source_uri_details.region}.oraclecloud.com/n/${oci_objectstorage_object.index_html.source_uri_details.namespace}/b/${oci_objectstorage_object.index_html.source_uri_details.bucket}/o/${oci_objectstorage_object.index_html.source_uri_details.object}"
}
