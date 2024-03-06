if curl -s ${BACKEND_URL}/hash/test | grep "098f6bcd4621d373cade4e832627b4f6"
then
    echo "Success!"
    exit 0
else
    echo "Correct hash not found!"
    exit 1
fi