base64 --decode ${oci_database_autonomous_database_wallet.autonomous_database_wallet.content} > wallet.zip
ls
mkdir -p ./network/admin
mv wallet.zip ./network/admin/
#sh gen_apex.sh
cd ./network/admin
unzip -q wallet.zip
cd ../..
export url=$(grep -oP '(?<=service_name=)[^_]*' ./network/admin/tnsnames.ora | echo "https://$(head -n 1)-pricing.adb.${region}.oraclecloudapps.com/ords/priceadmin")
export apex=$(grep -oP '(?<=service_name=)[^_]*' ./network/admin/tnsnames.ora | echo "https://$(head -n 1)-pricing.adb.${region}.oraclecloudapps.com/ords/r/priceadmin/price-admin/login")
echo $url
echo $apex