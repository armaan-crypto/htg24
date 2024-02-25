from flask import Flask, jsonify, request
import google.generativeai as genai
import yfinance as yf
import numpy as np
from datetime import datetime, timedelta
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel
import pandas as pd
import yfinance as yf
import json

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
    
def filter(sector, risk_will=100):
    df = pd.read_csv('api/constituents_csv.csv', sep=',')
    sector_df = df[df['Sector'] == sector]

    filtered_dataframe = sector_df.copy()
    for index, row in sector_df.iterrows():
        try:
            risk_result = riskScore(row['Symbol'])
            if risk_result is not None:
                value = risk_result['risk']
                # Rest of your code
                if value is not None and value > risk_will:
                    filtered_dataframe = filtered_dataframe.drop(index)
                else:
                    # Append the percent score for each stock in a new row of the DataFrame
                    filtered_dataframe.loc[index, 'Percent Score'] = value

        except KeyError:
            pass

    filtered_dataframe = filtered_dataframe.reset_index(drop=True)

    return filtered_dataframe

def get_recommendations_for_symbol(selected_symbol, sector="Information Technology", top_n=4):
    # Filter DataFrame by sector
    df = filter(sector)

    # Convert 'Percent Score' to string and fill missing values with "50"
    df['Percent Score'] = df['Percent Score'].apply(lambda x: str(x) if pd.notna(x) else "50")

    # Compute the TF-IDF matrix
    tfidf = TfidfVectorizer(stop_words='english')
    tfidf_matrix = tfidf.fit_transform(df['Percent Score'])

    # Compute cosine similarity
    cosine_sim = linear_kernel(tfidf_matrix, tfidf_matrix)

    # Get movie recommendations based on cosine similarity
    idx_list = df.index[df['Symbol'].str.lower() == selected_symbol.lower()].tolist()
    print(idx_list)
    if idx_list:
        idx = idx_list[0]
        sim_scores = list(enumerate(cosine_sim[idx]))
        sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
        sim_scores = sim_scores[1:top_n + 1]
        movie_indices = [i[0] for i in sim_scores]
        recommended_data = df.iloc[movie_indices][['Symbol', 'Name']].values
        print('RECCOMMENEDEDD')
        print(type(recommended_data))
        return {"recommendations": recommended_data}
    
    else:
        return {"recommendations": [['PAYC', 'Paycom'], ['CRM', 'Salesforce'], ['ACN', 'Accenture'], ['ADBE', 'Adobe']]}


@app.route('/')
def home():
    return 'Go to /api/describe'

@app.route('/api/describe', methods=['GET'])
def describe_api():
    stock_symbol = request.args.get('symbol')
    description = describe(stock_symbol)
    score = riskScore(stock_symbol)

    description.update(score)
    # description.update(recommendations)

    return jsonify(description)


@app.route('/api/rec', methods=['GET'])
def rec_api():
    stock_symbol = request.args.get('symbol')
    sector_in = request.args.get('sector')
    recommendations = get_recommendations_for_symbol(stock_symbol, sector_in, top_n=4)
    return jsonify(recommendations)

if __name__ == '__main__':
    app.run(debug=True)