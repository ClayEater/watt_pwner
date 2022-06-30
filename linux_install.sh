 
echo "Installing watt_pwner dependencies.."
curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh
./lit install creationix/coro-http
./lit install luvit/json
./lit install luvit/secure-socket