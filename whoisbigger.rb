require "rubygems"
require "sinatra"
require "yahoofinance"
require "bigdecimal"
require "bigdecimal/util"

helpers do
  def to_dollars(cap)
    val = cap.to_s
    if cap =~ /(\d)*M/ then
      (BigDecimal(val) * BigDecimal("1E6")).to_i
    elsif cap =~ /(\d)*B/ then 
      (BigDecimal(val) * BigDecimal("1E9")).to_i
    else
      val.to_i
    end
  end
  
  def google_chart_for(quote1, quote2)
    marketCap1 = to_dollars(quote1.marketCap)
    marketCap2 = to_dollars(quote2.marketCap)
    
    
    if marketCap1 > marketCap2
      topValue = marketCap1
    else
      topValue = marketCap2
    end

    # let Google figure the scaling out...
    "<img src='http://chart.apis.google.com/chart?cht=p3&chs=500x200&chd=t:#{to_dollars(quote1.marketCap)},#{to_dollars(quote2.marketCap)}&chds=1,#{topValue}&chl=#{quote1.name}|#{quote2.name}'>"

  end
end

get '/' do
  erb :index
end

get '/compare' do
  stock1 = params["stock1"]
  stock2 = params["stock2"]
  
  quote_type = YahooFinance::ExtendedQuote
  quote_symbols = "#{stock1},#{stock2}"
  
  @quotes = YahooFinance::get_quotes(quote_type, quote_symbols)
  @quote1 = @quotes[stock1]
  @quote2 = @quotes[stock2]
  
  erb :compare
end


