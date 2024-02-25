import yfinance as yf
import numpy as np
from datetime import datetime, timedelta
import pandas as pd
from currprice import get_current_stock_price
import warnings
import requests




def is_increasing(ticker):
    # Retrieve historical data
    current_date_time = datetime.now()
    yesterday = current_date_time - timedelta(days=1)
    one_month_ago = current_date_time - timedelta(days=30)
    start_date = one_month_ago.date()
    end_date = yesterday.date()

    stock_data = yf.download(ticker, start=start_date, end=end_date)
    current_price = get_current_stock_price(ticker)
    # Calculate the percentage change
    if current_price is None:
        return None

    percentage_change = (current_price - stock_data['Close'][-1]) 
    
    # Check if the stock is increasing
    return round(percentage_change,2)