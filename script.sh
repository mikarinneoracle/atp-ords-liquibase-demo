export region='eu-amsterdam-1'
export compt_ocid='<YOUR COMPARTMENT OCID>'
export ocid=$(oci db autonomous-database create --compartment-id  $compt_ocid --db-name pricing --cpu-core-count 1 --data-storage-size-in-tbs 1 --admin-password 'WelcomeFolks123#!' --display-name pricing | jq -r '.data.id')
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
sh gen_apex.sh
oci db autonomous-database generate-wallet --autonomous-database-id $ocid --password 'WelcomeFolks123#!' --file wallet.zip
mkdir -p network/admin
mv wallet.zip network/admin/
cd network/admin
unzip wallet.zip
cd ../..
export url=$(grep -oP '(?<=service_name=)[^_]*' ./network/admin/tnsnames.ora | echo "https://$(head -n 1)-pricing.adb.${region}.oraclecloudapps.com/ords/r/priceadmin/price-admin/login")
sed -i "s/URL/$url/g" vue.js
oci os bucket create --compartment-id  $compt_ocid --name pricing --public-access-type ObjectReadWithoutList
oci os object put --force --bucket-name pricing --file index.html --content-type "text/html" --force
oci os object put --force --bucket-name pricing --file vue.js --content-type "text/javascript" --force
oci os object put --force --bucket-name pricing --file pricing.css  --content-type "text/css" --force