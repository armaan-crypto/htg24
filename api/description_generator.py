import google.generativeai as genai

def describe(stock):
    genai.configure(api_key=GOOGLE_API_KEY)
    model = genai.GenerativeModel('gemini-pro')
    response = model.generate_content("Generate a concise 3 sentence paragraph about the company " + stock)

    return {"description": response.text}
