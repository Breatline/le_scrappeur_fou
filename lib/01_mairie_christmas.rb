require 'rubygems'
require 'nokogiri'
require 'open-uri'

def main_page_url
    page = Nokogiri::HTML(URI.open('https://www.annuaire-des-mairies.com/val-d-oise.html'))
    return page
end

def get_base_url
    base_url = "https://www.annuaire-des-mairies.com"
    return base_url
end

def get_communes_names(page)
    noms_communes = page.css("a.lientxt").map{|nom| nom.text}
    return noms_communes
end

def get_communes_url(page)
    url_commune = page.xpath('//*//a//@href').map{|url| url.to_s}
    url_commune_clean = url_commune.slice!(8...193).each{|commune| commune.slice!(0)}
    return url_commune_clean
end


def get_communes_infos(base_url, noms_communes, url_commune_clean)
    array_emails = Array.new
    commune_emails_hashes = Array.new
    url_commune_clean.length.times do |i|
        url_par_commune = Nokogiri::HTML(URI.open("#{base_url + url_commune_clean[i]}"))
        array_emails.push(url_par_commune.xpath("//*/section[2]/div/table/tbody/tr[4]/td[2]").text)
        commune_emails_hashes.push(noms_communes[i] => array_emails[i])
    end
    puts commune_emails_hashes
end

def perform
    page = main_page_url
    base_url = get_base_url
    noms_communes = get_communes_names(page)
    url_commune_clean = get_communes_url(page)
    get_communes_infos(base_url, noms_communes, url_commune_clean)
end

perform










