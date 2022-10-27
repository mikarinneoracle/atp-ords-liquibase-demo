echo $1 > wallet64
base64 --decode wallet64 > wallet.zip
mkdir -p ./network/admin
mv wallet.zip ./network/admin/
#sh gen_apex.sh
cd ./network/admin
unzip -q wallet.zip
cd ../..
ls -R
grep -oP '(?<=service_name=)[^_]*' ./network/admin/tnsnames.ora | echo $(head -n 1)
