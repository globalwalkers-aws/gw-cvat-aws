#! /usr/bin/bash
# Author: Ye Yint Thu
# Email: yeyintthu@globalwalkers.co.jp

# varialbles
awscli_url=https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
aws_zip=awscliv2.zip
aws_tmp_dir=/tmp/aws_tmp
aws_region=ap-southeast-2
bucket_name=gw-cvat
versions_json=versions.json
cvat_zip_name=cvat_volume_backup.zip
num_keep_versions=5
# get command line variabes
cvat_volume=$1
aws_credentials_path=$2

# create tmp folder
mkdir $aws_tmp_dir
# check awscli is already installed otherwise install first
if ! [ -x "$(command -v $(whereis aws))" ]
then
    echo 'awscli is not installed.'
    echo 'installing awscli..'
    # install awscli

    aws_zip_path=$aws_tmp_dir/$aws_zip
    curl $awscli_url -o $aws_zip_path
    unzip $aws_zip_path -d $aws_tmp_dir/
    $aws_tmp_dir/aws/install

else
    echo 'awscli is already installed.'
fi

# get aws command path
aws_cmds_info=($(whereis aws))
aws_command=${aws_cmds_info[1]}

# get aws access keys
aws_credentials=$(head -2 $aws_credentials_path | tail -1)
IFS="," read -a aws_credentials_arr <<< $aws_credentials
aws_access_key=${aws_credentials_arr[0]}
aws_secret_access_key=${aws_credentials_arr[1]}


# set credentials as environment variables
$aws_command configure set aws_access_key_id $aws_access_key && \
$aws_command configure set aws_secret_access_key $aws_secret_access_key && \
$aws_command configure set region $aws_region

# zip cvat volume for backup
out_zip_path=$aws_tmp_dir/$cvat_zip_name
cwd=$(pwd)
cd $cvat_volume
zip -r $out_zip_path  *
cd $cwd
$aws_command s3 cp $out_zip_path s3://$bucket_name/$zip_name

echo "Getting list of object versions.."
# get list of versions of backup object
$aws_command s3api list-object-versions --bucket gw-cvat > $aws_tmp_dir/$versions_json

# check jq is already installed otherwise install first
if ! [ -x "$(command -v $(whereis jq))" ]
then
    echo "installing jq.."
    apt install jq -y
fi
# get jq command path
jq_cmds_info=($(whereis jq))
jq_command=${jq_cmds_info[1]}

# read into bash array
readarray -t versions_arr < <($jq_command -r '.Versions[].VersionId' $aws_tmp_dir/$versions_json)

# delete oldest version if number of versions exceeds a certain number of versions limit
if ((${#versions_arr[@]} > $num_keep_versions))
then
    $aws_command s3api delete-object --bucket $bucket_name --key $cvat_zip_name --version-id ${versions_arr[-1]}
    echo "Object-version ${versions_arr[-1]} has been deleted!"
else
    echo "No version to be deleted!"
fi

# clean tmp folder
echo 'Cleaning tmp folder..'
rm -rf $aws_tmp_dir

echo 'Done!'
