import requests
api_key = "0WCHDS8EX4GHOOC4"

def get_current_stock_price(symbol):
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