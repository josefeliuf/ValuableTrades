class TablesController < ApplicationController
  def index
    markets_url = 'https://www.buda.com/api/v2/markets'

    trades_by_market = get_trades(
                          get_buda_markets(
                              get_response(markets_url)))

    @most_valuable_trades = get_most_valuable_trades(trades_by_market, {})
  end

  private 

  def get_response(url)
    response = HTTParty.get(url)
    response = response.parsed_response
    return response
  end


  def get_buda_markets(markets)
    markets_ids = []
    markets["markets"].each do |market|
      market_id = market["name"]
      markets_ids.push market_id
    end
    return markets_ids
  end

  def get_trades(markets_ids)
    trades_by_market = []
    markets_ids.each do |market_id|
      url = "https://www.buda.com/api/v2/markets/#{market_id}/trades"
      trade = get_response(url)
      trades_by_market.push(trade)
    end
    return trades_by_market
  end

  def get_most_valuable_trades(trades_by_market, most_valuable_entries)

    trades_by_market.each do |trade|

      most_valuable_trade = 0
      most_valuable_entrie = nil
      market_id = trade["trades"]["market_id"]
      entries = trade["trades"]["entries"]

      entries.each do |entrie|

        value = entrie[1].to_f * entrie[2].to_f

        if value > most_valuable_trade
          most_valuable_trade = value
          most_valuable_entrie = entrie
        end

      end

      most_valuable_entries[market_id] = most_valuable_entrie

    end

    return most_valuable_entries

  end

end
