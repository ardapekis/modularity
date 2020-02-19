set -e

download_all=0
while getopts "a" opt; do
    case "$opt" in
    a)  download_all=1
    esac
done

echo "Finalizing Build!"
echo "#################"


echo "Paste your AWS access key, followed by [ENTER]"
read aws_access

echo "Paste your AWS secret key, followed by [ENTER]"
read aws_secret

mkdir -p ~/.aws

printf "[default]\nregion = us-west-1" > ~/.aws/config

printf "[default]\naws_access_key_id = %s\naws_secret_access_key = %s" $aws_access $aws_secret > ~/.aws/credentials

rm -rf nn_modularity
echo "Cloning repo..."
git clone https://github.com/nn-surprisingly-modular-icml-2020/nn_modularity.git

cd nn_modularity

echo "Installing Python dependencies..."
# PIP_USER=yes  # install as --user
pipenv install --system

echo "Patching scipy and sklearn..."
python -m site | grep /usr/local/lib/python3.7/dist-packages || { echo "Cannot find dist-packages directory for patching of scipy and sklearn"; exit 1; }
cp -r devops/patches/* /usr/local/lib/python3.7/dist-packages


echo "Downloading results folder"
aws s3 cp --recursive s3://nn-modularity/results results

if [ $download_all -gt 0 ]
then
    echo "Downloading models folder, including checkpoints. Hold tight, this might take a while"
    aws s3 cp --recursive s3://nn-modularity/models models
else
    echo "Downloading models folder, excluding checkpoints"
    aws s3 cp --recursive --exclude "*.ckpt" s3://nn-modularity/models models

fi


echo "Downloading datasets folder"
aws s3 cp --recursive s3://nn-modularity/datasets datasets

cd ..

echo "Deleting this script - you can find it in the repo!"
rm build.sh
