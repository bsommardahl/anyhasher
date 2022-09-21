if curl -s ${BACKEND_URL}/hash/test | grep "098f6bcd4621d373cade4e832627b4f6"
then
    exit 1
else
    exit 0
fi