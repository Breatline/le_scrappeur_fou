require 'rubygems'
require 'nokogiri'
require 'open-uri'

def main_page_url
    page = Nokogiri::HTML(URI.open("https://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
    return page
end

def get_base_url
    url_base = "https://www2.assemblee-nationale.fr"
    return url_base
end

def get_url_député(page)
    url_mobile_député = page.xpath('//*[@id="deputes-list"]//a//@href').map{|url| url.text}
    return url_mobile_député
end


def final_députés_infos(url_base, url_mobile_député)
    final_député = Array.new

    url_mobile_député.length.times do |i|
        url_one_député = Nokogiri::HTML(URI.open("#{url_base + url_mobile_député[i]}"))
        url_one_député_infos = url_one_député.xpath('//*[@id="haut-contenu-page"]/article/div[2]/h1').text.split
        url_one_député_infos.slice!(0)
        url_one_député_infos_1 = url_one_député_infos.join(" ")
        url_one_député_infos_2 = url_one_député_infos_1.split(/ /, 2)
        url_one_député_infos_2.push(url_one_député.xpath('//*[@id="haut-contenu-page"]/article/div[3]/div/dl/dd/ul/li[2]/a').text)
        final_député.push("Prénom" => url_one_député_infos_2[0], "Nom" => url_one_député_infos_2[1], "Email" => url_one_député_infos_2[2])
    end
    
    puts final_député

end

def perform
    page = main_page_url
    url_base = get_base_url
    url_mobile_député = get_url_député(page)
    final_députés_infos(url_base, url_mobile_député)
end

perform
