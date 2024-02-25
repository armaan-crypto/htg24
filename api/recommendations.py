import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import linear_kernel
from sector_filter import filter

def get_recommendations_for_symbol(selected_symbol, sector, top_n=4):
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
    idx = df.index[df['Symbol'] == selected_symbol].tolist()[0]
    sim_scores = list(enumerate(cosine_sim[idx]))
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
    sim_scores = sim_scores[1:top_n + 1]
    movie_indices = [i[0] for i in sim_scores]
    recommended_data = df.iloc[movie_indices][['Symbol', 'Name']].values

    return recommended_data

# Example usage
selected_symbol = 'AAPL'  # Replace with a valid symbol from your DataFrame
recommended_data = get_recommendations_for_symbol(selected_symbol, sector="Information Technology")
print(recommended_data)