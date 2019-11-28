clear;
nimble install -y;
# nim c src/server.nim;
# ./src/server;
# ./server &> server.log;
server 2>&1 | tee server.log;