from percent import getScore
from change import is_increasing
from sector_filter import filter

# def choosenew(t1, r1, t2, r2, t3, r3, category):
#     # t1per = getScore(t1)
#     # t2per = getScore(t2)
#     # t3per = getScore(t3)
#     # t1change = is_increasing(t1)
#     # t2change = is_increasing(t2)
#     # t3change = is_increasing(t3)

#     # weighted_average_s = 0; 
#     # weighter_average_up = 0; 
#     # count = 0; 
#     # if r1==True and t1change is not None: 
#     #     weighted_average_s += t1per
#     #     weighter_average_up += t1change
#     #     count+=1
#     # if r2==True and t2change is not None: 
#     #     weighted_average_s += t2per
#     #     weighter_average_up += t2change
#     #     count+=1
#     # if r3==True and t3change is not None: 
#     #     weighted_average_s += t3per
#     #     weighter_average_up += t3change
#     #     count+=1 

#     # weighted_average_s = weighted_average_s 
#     # weighter_average_up = weighter_average_up 
    

#     df = filter(sector=category, risk_will=100)

#     # print(df.head())
    
#     # Check if df is None, if so, return None
#     if df is None:
#         return None
    
#     similar_stocks = []
#     for index, row in df.iterrows():
#         try:
#             similar_stocks.append(row['Symbol'])  # Add the symbol to the list of similar stocks
#         except KeyError:
#             return None

#     return similar_stocks

print(choosenew('AAPL', True, 'AMZN', False, 'ACN', True, 'Information Technology'))