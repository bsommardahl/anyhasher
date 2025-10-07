if curl -s ${BACKEND_URL}/hash/test | grep "098f6bcd4621d373cade4e832627b4f6"
then
    echo "Hashed correctly."    
else
    echo "Correct hash not found!"
    exit 1
fi

ENHANCED_RESPONSE_ENABLED=$(grep "^FEATURE_ENHANCED_RESPONSE=" /.feature-flags | cut -d'=' -f2)
if curl -s ${BACKEND_URL}/feature-flags/enhanced_response | grep "\"enabled\": *${ENHANCED_RESPONSE_ENABLED}"
then
    echo "Enhanced response feature flag is ${ENHANCED_RESPONSE_ENABLED} (correct)."
else
    echo "Enhanced response feature flag is not ${ENHANCED_RESPONSE_ENABLED} (incorrect)!"
    exit 1
fi

exit 0