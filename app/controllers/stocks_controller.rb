class StocksController < ApplicationController
  def search
    # Check the data (the name of the stock) that is sent to the controller search
    if params[:stock]
      # Search the stock to see whether it is already in the database or not.
      @stock = Stock.find_by_ticker(params[:stock])
      # If the stock is not in the database then search online by using the methods from the gem stock_quote
      @stock ||= Stock.new_from_lookup(params[:stock])
    end

    # Next action after search for the stock
    if @stock
      # Use this trick to test whether my method can search for a stock or not by typing localhost:3000/search_stocks?stock=GOOG
      # render json: @stock
      render partial: 'lookup'
    else
      render status: :not_found, nothing: true
    end
  end
end
