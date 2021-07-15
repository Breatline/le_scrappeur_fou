require 'rubygems'
require 'nokogiri'
require 'open-uri'

def main_page_url
    page = Nokogiri::HTML(URI.open("https://coinmarketcap.com/all/views/all/"))
    return page
end

def get_ticker_crypto(page)
    ticker_crypto = page.css('td.cmc-table__cell--sort-by__symbol').map{|ticker| ticker.text}
    return ticker_crypto
end

def get_price_crypto(page)
    price_crypto = page.css('td.cmc-table__cell--sort-by__price').map{|price| price.text}
    price_crypto_clean = price_crypto.map{|i| i.gsub(/[$,]/,'')}
    price_crypto_clean.map{|price| price.to_f}
    return price_crypto_clean
end

def final_resultat_crypto_hash(ticker_crypto, price_crypto_clean)
    final_crypto = Array.new
    ticker_crypto.length.times do |i|
        final_crypto.push(ticker_crypto[i] => price_crypto_clean[i])
    end
    puts final_crypto
end


def perform
    page = main_page_url
    ticker_crypto = get_ticker_crypto(page)
    price_crypto_clean = get_price_crypto(page)
    final_resultat_crypto_hash(ticker_crypto, price_crypto_clean)
end

perform