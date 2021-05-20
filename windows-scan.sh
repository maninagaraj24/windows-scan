#!/bin/bash

userId=$1
rowId=$2
ip=$3
port=$4
username=$5
password="$6"
host_url=$7

datetime=$(date +%d-%m-%Y-%H%M%S)

basedir=/opt/windows-scan
sourcedir=$basedir/source-files
reportsdir=$basedir/reports
sssbucket=dra-reports

log=$reportsdir/$ip-$rowId.log

function usage()
{
    echo "Usage: windows-scan.sh script to scan remote Windows Server"
    echo
    echo "$ bash windows-scan.sh {user-id} {row-id} {ip} {port} {userName} {password}"
    echo "$ bash windows-scan.sh admin@gurupada.digital 001 15.207.72.104 5985 Administrator \"@dmin@123\""
    echo
}

function die()
{
    echo "$*" >&2
    /usr/bin/curl -X POST -H "Content-Type: application/json" -d '{"resultId": '$rowId', "status": 4, "url":""}' $host_url/api/updateFailure
    exit 1
}

if [ $# -lt 6 ]; then
    echo
    echo "Error: Missing server/user details. Please pass UserId, rowId, IP, WinRM Port, userName and password details."
    echo
    usage
    die
fi

sed -i "s/192.168.2.0/$ip/g" $sourcedir/hosts
sed -i "s/192.168.2.0/$ip/g" $sourcedir/windows-scan.yaml
sed -i "s/192.168.2.0/$ip/g" $sourcedir/windows-copy.yaml
sed -i "s/devadmin/$username/g" $sourcedir/hosts
#sed -i "s/gpadmin/$password/g" $sourcedir/hosts
sed -i "s/0000/$port/g" $sourcedir/hosts

/usr/bin/ansible-playbook -i $sourcedir/hosts $sourcedir/windows-scan.yaml -e "ansible_password=$password" -vvv

/usr/bin/ansible-playbook -i $sourcedir/hosts $sourcedir/windows-copy.yaml -e "ansible_password=$password" -vvv

/usr/bin/aws s3 cp $reportsdir/results.csv s3://$sssbucket/windows-scan/$userId/$rowId/
/usr/bin/aws s3 cp $reportsdir/usedport.txt s3://$sssbucket/windows-scan/$userId/$rowId/
/usr/bin/aws s3 cp $reportsdir/uac.txt s3://$sssbucket/windows-scan/$userId/$rowId/
/usr/bin/aws s3 cp $reportsdir/shares.txt s3://$sssbucket/windows-scan/$userId/$rowId/
/usr/bin/aws s3 cp $reportsdir/interfaces.txt s3://$sssbucket/windows-scan/$userId/$rowId/
/usr/bin/aws s3 cp $reportsdir/basicuserinfo.txt s3://$sssbucket/windows-scan/$userId/$rowId/
/usr/bin/aws s3 cp $reportsdir/admingroup.txt s3://$sssbucket/windows-scan/$userId/$rowId/
/usr/bin/aws s3 cp $reportsdir/hostfile.txt s3://$sssbucket/windows-scan/$userId/$rowId/
/usr/bin/aws s3 cp $reportsdir/firewall.txt s3://$sssbucket/windows-scan/$userId/$rowId/

echo "https://$sssbucket.s3.ap-south-1.amazonaws.com/windows-scan/$userId/$rowId/results.csv"

/usr/bin/curl -X POST -H "Content-Type: application/json" -d '{"resultId": '$rowId', "status": 2, "url":"https://'$sssbucket'.s3.ap-south-1.amazonaws.com/windows-scan/'$userId/$rowId'/results.csv###https://'$sssbucket'.s3.ap-south-1.amazonaws.com/windows-scan/'$userId/$rowId'/usedport.txt###https://'$sssbucket'.s3.ap-south-1.amazonaws.com/windows-scan/'$userId/$rowId'/uac.txt###https://'$sssbucket'.s3.ap-south-1.amazonaws.com/windows-scan/'$userId/$rowId'/shares.txt###https://'$sssbucket'.s3.ap-south-1.amazonaws.com/windows-scan/'$userId/$rowId'/interfaces.txt###https://'$sssbucket'.s3.ap-south-1.amazonaws.com/windows-scan/'$userId/$rowId'/basicuserinfo.txt###https://'$sssbucket'.s3.ap-south-1.amazonaws.com/windows-scan/'$userId/$rowId'/admingroup.txt###https://'$sssbucket'.s3.ap-south-1.amazonaws.com/windows-scan/'$userId/$rowId'/hostfile.txt###https://'$sssbucket'.s3.ap-south-1.amazonaws.com/windows-scan/'$userId/$rowId'/firewall.txt"}' $host_url/updateResult

#rm -rf $srcdir
#rm -rf $reportsdir

exit 0
