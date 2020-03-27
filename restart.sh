#!/bin/bash
kill -9 $(lsof -t -i:5001)
kill -9 $(lsof -t -i:5005)
kill -9 $(lsof -t -i:8000)

nohup rasa run --enable-api --cors "*" --debug &

cd ./rasa-ui
nohup npm start &

cd ../trivago
nohup python server.py &

