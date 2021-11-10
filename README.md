# Serverless Image Resizing

## Description

Resizes images on the fly using Amazon S3, AWS Lambda, and Amazon API Gateway.
Using a conventional URL structure and S3 static website hosting with
redirection rules, requests for resized images are redirected to a Lambda
function via API Gateway which will resize the image, upload it to S3, and
redirect the requestor to the resized image. The next request for the resized
image will be served from S3 directly.

## Usage

1. Build the Lambda function

   The Lambda function uses [sharp][sharp] for image resizing which requires
   native extensions. In order to run on Lambda, it must be packaged on Amazon
   Linux. You can accomplish this in one of two ways:

   - Upload the contents of the `lambda` subdirectory to an [Amazon EC2 instance
     running Amazon Linux][amazon-linux] and run `npm install`, or

   - Use the Amazon Linux Docker container image to build the package using your
     local system. This repo includes Makefile that will download Amazon Linux,
     install Node.js and developer tools, and build the extensions using Docker.
     Run `make all`.

2. Deploy the Terraform stack
    
    https://github.com/thisisonetv/one-terraform

    Add the built zip file to the `modules/lambda/js` directory and update the `image_library` variable in the clients tf file.

3. Test the function

    Upload an image to the S3 bucket and try to resize it via your web browser
    to different sizes, e.g. with an image uploaded in the bucket called
    image.png:

    - http://[BucketWebsiteHost]/300x300/path/to/image.png
    - http://[BucketWebsiteHost]/90x90/path/to/image.png
    - http://[BucketWebsiteHost]/40x40/path/to/image.png

    You can find the `BucketWebsiteUrl` in the table of outputs displayed on a
    successful invocation of the deploy script.

4. (Optional) Restrict resize dimensions

    To restrict the dimensions the function will create, set the environment
    variable `ALLOWED_DIMENSIONS` to a string in the format
    *(HEIGHT)x(WIDTH),(HEIGHT)x(WIDTH),...*.

    For example: *300x300,90x90,40x40*.

## "Archived"

The base image in use has been archived, with further updates by ONE to keep this one going.
Ideally we update to use https://github.com/awslabs/serverless-image-handler instead.

## License

This reference architecture sample is [licensed][license] under Apache 2.0.

[license]: LICENSE
[sharp]: https://github.com/lovell/sharp
[amazon-linux]: https://aws.amazon.com/blogs/compute/nodejs-packages-in-lambda/
[cli]: https://aws.amazon.com/cli/
[aws-configure]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
