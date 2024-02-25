from flask import Flask, jsonify, request
from yahoo_fin import stock_info
import google.generativeai as genai

app = Flask(__name__)



GOOGLE_API_KEY = 'AIzaSyBEH0mo0PAabKy80amr5_nzBf6Gh5VdiAA'

def describe(stock):
    genai.configure(api_key=GOOGLE_API_KEY)
    model = genai.GenerativeModel('gemini-pro')
    response = model.generate_content("Generate 2 short sentences describing this company: " + stock)
    return {"description": response.text}



@app.route('/')
def home():
    return 'Go to /api/describe'

@app.route('/api/describe', methods=['GET'])
def describe_api():
    stock_symbol = request.args.get('symbol')
    description = describe(stock_symbol)
    return jsonify(description)

if __name__ == '__main__':
    app.run(debug=True)