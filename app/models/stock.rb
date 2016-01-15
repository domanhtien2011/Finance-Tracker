class Stock < ActiveRecord::Base
  has_many :user_stocks
  has_many :users, through: :user_stocks

  # Search whether the stock is already in the database or not
  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  # Search stock online by using the gem stock_quote
  def self.new_from_lookup(ticker_symbol)
    looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
    return nil unless looked_up_stock.name

    new_stock = new(ticker: looked_up_stock.symbol, name: looked_up_stock.name)
    new_stock.last_price = new_stock.price
    new_stock
  end

  # Look for the stock'closing or opening price online by using the gem stock_quote
  def price
    closing_price = StockQuote::Stock.quote(ticker).close
    return "#{closing_price} (Closing)" if closing_price

    opening_price = StockQuote::Stock.quote(ticker).open
    return "#{opening_price} (opening)" if opening_price
    'Unavailable'
  end
end
