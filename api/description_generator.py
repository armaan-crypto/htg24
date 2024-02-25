import google.generativeai as genai

GOOGLE_API_KEY = 'AIzaSyBEH0mo0PAabKy80amr5_nzBf6Gh5VdiAA'

def describe(stock):
    genai.configure(api_key=GOOGLE_API_KEY)
    model = genai.GenerativeModel('gemini-pro')
    response = model.generate_content("Generate a concise 3 sentence paragraph about the company " + stock)

    return {"description": response.text}