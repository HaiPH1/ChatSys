#!/bin/bash
kill -9 $(lsof -t -i:5001)
kill -9 $(lsof -t -i:5005)
kill -9 $(lsof -t -i:8000)
