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
    raw_html = open(url).read # avoid encoding issue...
    Nokogiri::HTML(raw_html).css('#mois_resultats td td table table').each do |table|
      header = table.css('td:nth-child(2) span')
      puts header.map{ |s| s.inner_html.gsub(/<br>/, " ") }.join(' | ') unless header.empty?

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
end
