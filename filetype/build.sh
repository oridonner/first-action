version=$1

# build image
docker build -t lambda-filetype-function:$version .

# tag image
docker tag lambda-filetype-function:$version 736961895477.dkr.ecr.eu-west-2.amazonaws.com/lambda-function:$version
docker tag lambda-filetype-function:$version 736961895477.dkr.ecr.eu-west-2.amazonaws.com/lambda-function:latest

# push image
docker push 736961895477.dkr.ecr.eu-west-2.amazonaws.com/lambda-function:$version
docker push 736961895477.dkr.ecr.eu-west-2.amazonaws.com/lambda-function:latest
