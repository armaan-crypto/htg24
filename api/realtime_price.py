import yfinance as yf
import numpy as np
from datetime import datetime, timedelta
import pandas as pd
import warnings
import requests


def get_current_stock_price(symbol):
    api_key = "0WCHDS8EX4GHOOC4"
    url = f"https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol={symbol}&apikey={api_key}"
    try:
        response = requests.get(url)
        data = response.json()
        if "Global Quote" in data:
            return float(data["Global Quote"]["05. price"])
        else:
            return None
    except Exception as e:
        return None


def is_increasing(ticker):
    # Retrieve historical data
    current_date_time = datetime.now()
    yesterday = current_date_time - timedelta(days=1)
    one_month_ago = current_date_time - timedelta(days=30)
    
    start_date = one_month_ago.date()
    end_date = yesterday.date()

    stock_data = yf.download(ticker, start=start_date, end=end_date)
    
    # Calculate the percentage change
    percentage_change = (get_current_stock_price(ticker) - stock_data['Close'][-1]) 
    
    # Check if the stock is increasing
    return round(percentage_change,2) 

