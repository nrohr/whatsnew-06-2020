import pandas as pd

# Read our ETF data from a CSV file
stocks = pd.read_csv('https://colorado.rstudio.com/rsc/content/1255')
stocks.head()

# Calculate rolling averages for SPY
stocks.index = pd.to_datetime(stocks['date'], format='%Y-%m-%d')

spy = stocks.loc[:,'SPY']

short_rolling_spy = spy.rolling(window=20).mean()
long_rolling_spy = spy.rolling(window=100).mean()
