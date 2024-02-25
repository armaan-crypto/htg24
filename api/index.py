from flask import Flask, jsonify, request
import google.generativeai as genai
import yfinance as yf
import numpy as np
from datetime import datetime, timedelta
import requests


app = Flask(__name__)



GOOGLE_API_KEY = 'AIzaSyBEH0mo0PAabKy80amr5_nzBf6Gh5VdiAA'
api_key = "0WCHDS8EX4GHOOC4"



def describe(stock):
    genai.configure(api_key=GOOGLE_API_KEY)
    model = genai.GenerativeModel('gemini-pro')
    response = model.generate_content("Generate 3 short points describing this company: " + stock)
    return {"description": response.text}



    percentage_change = (current_price - stock_data['Close'][-1]) 
    
    # Check if the stock is increasing
    return {"displacement" : round(percentage_change,2)}

def riskScore(symbol):
    current_date_time = datetime.now()
    yesterday = current_date_time - timedelta(days=1)
    one_month_ago = current_date_time - timedelta(days=30)

    start = one_month_ago.date()
    end = yesterday.date()

    stock_data = yf.download(symbol, start, end);
    daily_returns = stock_data['Adj Close'].pct_change().dropna();
    stand = np.std(daily_returns)
    finalstd = pow(0.5, stand)

    # Range_based_volatility
    daily_range = stock_data['High'] - stock_data['Low']
    range_based_volatility = np.std(daily_range)
    final_based = pow(0.5, range_based_volatility)


    #Beta Value
    try:
        beta_value = yf.Ticker(symbol).info['beta']
        finalbeta = 0
        if (beta_value == 1):
            finalbeta = 0.5 
        if (beta_value < 0): 
            finalbeta = pow(0.5, 1+abs(beta_value))
        else:
            finalbeta = pow(0.5, beta_value-1)

        if (finalbeta > 0.6): 
            weightage_returns = 0.5
            weightage_volatility = 0.1
            weightage_beta = 0.4
        else: 
            weightage_beta = .8
            weightage_volatility = .025
            weightage_returns = .175

        overall_risk_factor = round(
            (weightage_returns * finalstd) +
            (weightage_volatility * final_based) +
            (weightage_beta * finalbeta), 2
        ) * 100

        return {"risk": overall_risk_factor}

    except KeyError:
        return None

@app.route('/')
def home():
    return 'Go to /api/describe'

@app.route('/api/describe', methods=['GET'])
def describe_api():
    stock_symbol = request.args.get('symbol')
    description = describe(stock_symbol)
    score = riskScore(stock_symbol)

    description.update(score)

    return jsonify(description)

@app.route('/api/score', methods=['GET'])
def score_api():
    stock_symbol = request.args.get('symbol')
    description = riskScore(stock_symbol)
    return jsonify(description)

if __name__ == '__main__':
    app.run(debug=True)