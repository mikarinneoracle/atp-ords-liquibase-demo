output "application_url_in_bucket" {
  value = "http://objectstorage.${oci_objectstorage_object.index_html.source_uri_details[0].region}.oraclecloud.com/n/${oci_objectstorage_object.index_html.source_uri_details[0].namespace}/b/${oci_objectstorage_object.index_html.source_uri_details[0].bucket}/o/${oci_objectstorage_object.index_html.source_uri_details[0].object}"
}
