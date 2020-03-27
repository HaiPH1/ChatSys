#!/bin/bash
nohup rasa run --enable-api --cors "*" --debug &

cd ./rasa-ui
nohup npm start &

cd ../trivago
nohup python server.py &

