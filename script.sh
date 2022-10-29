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
oci db autonomous-database generate-wallet --autonomous-database-id $ocid --password 'WelcomeFolks123#!' --file wallet.zip
mkdir -p ./network/admin
mv wallet.zip ./network/admin/
echo "------------- quick fix to run with older version of SQLcli (scripts fail with the latest Nov 27th 2022) ----------"
wget https://objectstorage.eu-amsterdam-1.oraclecloud.com/p/BydeV7ct283Y4F2S9PECPEyeNI-U3xoaghdLQ0EuzNUEDIMoieyqu5uA7xJ-syyq/n/frsxwtjslf35/b/oracledb/o/jdk-11.0.16_linux-x64_bin.tar.gz -q
tar -xzf jdk-11.0.16_linux-x64_bin.tar.gz
export PATH=./jdk-11.0.16/bin:$PATH
export JAVA_HOME=./jdk-11.0.16
wget https://objectstorage.eu-amsterdam-1.oraclecloud.com/p/rBz7NIZQsEXsXN6yqnLn8m9fLmTHZUY7Z5uhPBBUzsoiW0ceUoY1jyU5y7DjEWJx/n/frsxwtjslf35/b/oracledb/o/V1022102-01.zip -q
unzip -q V1022102-01.zip
./sqlcl/bin/sql -v
echo "-------------------------------------------------------------------------------------------------------------------"
sh gen_apex.sh
cd ./network/admin
unzip -q wallet.zip
cd ../..
export url=$(grep -oP '(?<=service_name=)[^_]*' ./network/admin/tnsnames.ora | echo "https://$(head -n 1)-pricing.adb.${region}.oraclecloudapps.com/ords/priceadmin")
export apex=$(grep -oP '(?<=service_name=)[^_]*' ./network/admin/tnsnames.ora | echo "https://$(head -n 1)-pricing.adb.${region}.oraclecloudapps.com/ords/r/priceadmin/price-admin/login")
echo $url
echo $apex
sed -i "s|\${URL}|$url|g" vue.js
sed -i "s|\${URL}|$apex|g" index.html
oci os bucket create --compartment-id  $compt_ocid --name pricing --public-access-type ObjectReadWithoutList
oci os object put --force --bucket-name pricing --file index.html --content-type "text/html" --force
oci os object put --force --bucket-name pricing --file vue.js --content-type "text/javascript" --force
oci os object put --force --bucket-name pricing --file pricing.css  --content-type "text/css" --force