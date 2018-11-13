
ds=$1
file=$2
project=$3
#echo "tunnel upload  ${file} ${project}.ods_bill_old_sys_temp_dd/pt='${ds}' -c gbk"
sh /home/webmaster/odpscmd/bin/odpscmd &
#echo "alter table ${project}.ods_bill_old_sys_temp_dd drop if exists partition(pt='${ds}')"
#echo "tunnel upload  ${file} ${project}.ods_bill_old_sys_temp_dd/pt='${ds} -c gbk'"
/home/webmaster/odpscmd/bin/odpscmd -e "alter table ${project}.ods_bill_old_sys_temp_dd drop if exists partition(pt='${ds}')"
/home/webmaster/odpscmd/bin/odpscmd -e "alter table ${project}.ods_bill_old_sys_temp_dd add if not exists partition(pt='${ds}')"
/home/webmaster/odpscmd/bin/odpscmd -e "tunnel upload  ${file} ${project}.ods_bill_old_sys_temp_dd/pt='${ds}' -c gbk"
#echo "alter table ods_bill_old_sys_temp_dd add if not exists partition(pt='"ALEVE"${ds}')"
