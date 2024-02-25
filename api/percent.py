import yfinance as yf

import numpy as np
from datetime import datetime, timedelta
import pandas as pd
import warnings

with warnings.catch_warnings():
    # Setting values in-place is fine, ignore the warning in Pandas >= 1.5.0
    # This can be removed, if Pandas 1.5.0 does not need to be supported any longer.
    # See also: https://stackoverflow.com/q/74057367/859591
    warnings.filterwarnings(
        "ignore",
        category=FutureWarning,
        message=(
            ".*will attempt to set the values inplace instead of always setting a new array. "
            "To retain the old behavior, use either.*"
        ),
    )

def getScore(symbol):
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

    return overall_risk_factor