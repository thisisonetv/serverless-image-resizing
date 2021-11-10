'use strict';

const AWS = require('aws-sdk');
const S3 = new AWS.S3({
    signatureVersion: 'v4',
});
const Sharp = require('sharp');

const BUCKET = process.env.BUCKET;
const URL = process.env.URL;
const ALLOWED_DIMENSIONS = new Set();

if (process.env.ALLOWED_DIMENSIONS) {
    const dimensions = process.env.ALLOWED_DIMENSIONS.split(/\s*,\s*/);
    dimensions.forEach((dimension) => ALLOWED_DIMENSIONS.add(dimension));
}

exports.handler = async function (event, context, callback) {
    const key = event.queryStringParameters.key;
    const match = key.match(/((\d+)x(\d+|null))\/(.*)/);
    const dimensions = match[1];
    const width = parseInt(match[2], 10);
    var height = null
    if (match[3] != 'null') {
        height = parseInt(match[3], 10);
    }
    const originalKey = match[4];

    if (ALLOWED_DIMENSIONS.size > 0 && !ALLOWED_DIMENSIONS.has(dimensions)) {
        return {
            statusCode: '403',
            headers: {},
            body: '',
        };
    }

    const data = await S3.getObject({Bucket: BUCKET, Key: originalKey}).promise();
    const buffer = Sharp(data.Body)
        .resize(width, height)
        .toFormat('png')
        .toBuffer();

    await S3.putObject({
        Body: buffer,
        Bucket: BUCKET,
        ACL: 'public',
        ContentType: 'image/png',
        Key: key,
    }).promise();

    return {
        statusCode: '301',
        headers: {'location': `${URL}/${key}`},
        body: '',
    };
}
