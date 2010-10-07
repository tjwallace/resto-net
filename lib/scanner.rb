require 'nokogiri'
require 'open-uri'

class DataPage
  MONTHS = %w(JANVIER FEVRIER MARS AVRIL MAI JUIN JUILLET AOUT SEPTEMBRE OCTOBRE NOVEMBRE DECEMBRE)

  attr_reader :month, :year

  def initialize(month = nil, year = nil)
    @month = month || Date.today.month
    @year = year || Date.today.year
  end

  def scan
    Nokogiri::HTML(content).css('#mois_resultats td td table table').each do |table|
      header = table.css('td:nth-child(2) span')
      unless header.empty?
        header = header.map{ |s| s.inner_html.gsub(/<br>/, " ") }
        header << table.at_css('td:nth-child(3) span').inner_html
        puts header.join(' | ')
      end

      details = table.css('td')
      puts details.map{ |s| s.content[0..30].strip }.reject{ |s| s.empty? }.join(' | ') if details.count == 6
    end
  end

  def month_name
    MONTHS[@month - 1]
  end

  def url
    URI.encode "http://ville.montreal.qc.ca/portal/page?_pageid=2136,2655580&_dad=portal&_schema=PORTAL&mois=#{month_name}&annee=#{year}"
  end

  def content
    local_file = File.join Rails.root, 'data', sprintf("%d_%02d.html", @year, @month)
    if File.exists? local_file
      File.read local_file
    else
      open(url).read
    end
  end
end
