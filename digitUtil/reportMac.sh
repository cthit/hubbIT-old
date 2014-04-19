#!/bin/bash 

while true; do 
	curl -L -X PUT -H "Content-Type: application/json" -H 'Authorization: Token token="df2eeab39a0af2e5cea8831f8fa57c28"' -d '{"Mac": "EC:55:F9:94:E2:E1"}' http://129.16.182.106:3000/sessions.json && echo "success" && date; 
	sleep 5;
	curl -L -X PUT -H "Content-Type: application/json" -H 'Authorization: Token token="df2eeab39a0af2e5cea8831f8fa57c28"' -d '{"Mac": "AA:AA:AA:AA:AA:AA"}' http://129.16.182.106:3000/sessions.json && echo "success" && date; 
	sleep 30;
done
