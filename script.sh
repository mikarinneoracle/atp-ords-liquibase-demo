export region='eu-amsterdam-1'
export compt_ocid='<YOUR COMPARTMENT OCID>'
export ocid=$(oci db autonomous-database list --compartment-id $compt_ocid | jq -r '.data[] | select( ."db-name" == "pricing" ).id')
echo "ATP: $ocid"
export tries=0
export atp_status=''
while [ $tries -le 30 ] && [[ $atp_status != 'AVAILABLE' ]] 
do
  atp_status=$(oci db autonomous-database get --autonomous-database-id $ocid | jq -r '.data["lifecycle-state"]')
  echo "atp status: $tries $atp_status"
  tries=$(( $tries + 1 ))
  sleep 5
done
oci db autonomous-database generate-wallet --autonomous-database-id $ocid --password 'WelcomeFolks123#!' --file wallet.zip
mkdir -p network/admin
mv wallet.zip network/admin/
unzip network/admin/
sh gen_apex.sh
export atp_link=$(grep -oP '(?<=service_name=)[^_]*' ./network/admin/tnsnames.ora | echo "https://$(head -n 1)-pricing.adb.${region}.oraclecloudapps.com/ords/r/priceadmin/price-admin/login")
sed -i "s/URL/$url/g" vue.js
oci os bucket create --compartment-id  $compt_ocid --name pricing --public-access-type ObjectReadWithoutList
oci os object bulk-delete --bucket-name pricing --force
oci os object bulk-upload --bucket-name pricing --overwrite --src-dir . --content-type "text/html"
