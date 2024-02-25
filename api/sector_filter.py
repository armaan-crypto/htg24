# import pandas as pd
# from percent import getScore
# import yfinance as yf

# def filter(sector, risk_will=100):
#     df = pd.read_csv('constituents_csv.csv', sep=',')
#     sector_df = df[df['Sector'] == sector]

#     df = sector_df

#     filtered_dataframe = df.copy()
#     for index, row in filtered_dataframe.iterrows():
#         try:
#             value = getScore(row['Symbol'])
#             if value is not None and value <= risk_will:
#                 filtered_dataframe = filtered_dataframe.drop(index)
#         except KeyError:
#             return None
#     filtered_dataframe = filtered_dataframe.reset_index(drop=True)

#     return filtered_dataframe

import pandas as pd
from percent import getScore
import yfinance as yf
'''
def filter(sector, risk_will=100):
    df = pd.read_csv('constituents_csv.csv', sep=',')
    sector_df = df[df['Sector'] == sector]

    filtered_dataframe = sector_df.copy()
    for index, row in sector_df.iterrows():
        try:
            value = getScore(row['Symbol'])
            if value is not None and value > risk_will:
                filtered_dataframe = filtered_dataframe.drop(index)
        except KeyError:
            pass

    filtered_dataframe = filtered_dataframe.reset_index(drop=True)

    return filtered_dataframe
    '''
def filter(sector, risk_will=100):
    df = pd.read_csv('api/constituents_csv.csv', sep=',')
    sector_df = df[df['Sector'] == sector]

    filtered_dataframe = sector_df.copy()
    for index, row in sector_df.iterrows():
        try:
            value = getScore(row['Symbol'])
            if value is not None and value > risk_will:
                filtered_dataframe = filtered_dataframe.drop(index)
            else:
                # Append the percent score for each stock in a new row of the DataFrame
                filtered_dataframe.loc[index, 'Percent Score'] = value
        except KeyError:
            pass

    filtered_dataframe = filtered_dataframe.reset_index(drop=True)

    return filtered_dataframe