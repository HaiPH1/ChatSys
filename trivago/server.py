from flask import Flask
from flask import render_template, jsonify, request
import requests
import random

app = Flask(__name__)


@app.route("/chattest/")
def index():
    return render_template("index.html", title="Home")


app.config["DEBUG"] = True
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
