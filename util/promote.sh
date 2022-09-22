# 0) You need to set the followings for your case
CLOUDFRONT_DISTRIBUTION_ID="EABCDEF12345ABCD"
CLOUDFRONT_ORIGIN_ID="E1A2B3C4D5E6F" #what's this?
S3_BUCKET_URL="https://DOC-EXAMPLE-BUCKET.s3-website.us-west-2.amazonaws.com" 

DIST_CONFIG_OLD_FILENAME="dist-config.json" # a temp file, which will be removed later
DIST_CONFIG_NEW_FILENAME="dist-config2.json" # a temp file, which will be removed later

# 1) Get the current config, entirely, and put it in a file
aws cloudfront get-distribution --id $CLOUDFRONT_DISTRIBUTION_ID > $DIST_CONFIG_OLD_FILENAME

# 2) Extract the Etag which we need this later for update
Etag=`cat $DIST_CONFIG_OLD_FILENAME | jq '.ETag' | tr -d \"`

# 3) Modify the config as wished, for me I used `jq` extensively to update the "OriginPath" of the desired "originId"
cat $DIST_CONFIG_OLD_FILENAME | jq \
    --arg targetOriginId $CLOUDFRONT_ORIGIN_ID \
    --arg s3BucketUrl $S3_BUCKET_URL \
    '.Distribution.DistributionConfig | .Origins.Items = (.Origins.Items | map(if (.Id == $targetOriginId) then (.OriginPath = $s3BucketUrl) else . end))' \
    > $DIST_CONFIG_NEW_FILENAME

# 4) Update the distribution with the new file
aws cloudfront update-distribution --id $CLOUDFRONT_DISTRIBUTION_ID \
    --distribution-config "file://${DIST_CONFIG_NEW_FILENAME}" \
    --if-match $Etag \
    > /dev/null

# 5) Invalidate the distribution to pick up the changes
aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DISTRIBUTION_ID --paths "/*"

# 6) Clean up
rm -f $DIST_CONFIG_OLD_FILENAME $DIST_CONFIG_NEW_FILENAME