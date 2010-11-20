# encoding: utf-8
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
    establishments = []
    establishment = nil
    Nokogiri::HTML(content).css('#mois_resultats td td table table').each do |table|
      header = table.css('td:nth-child(2) span')
      unless header.empty?
        header = header.map{ |s| s.inner_html.gsub(/<br>/, " ").strip }
        header << table.at_css('td:nth-child(3) span').inner_html.strip

        establishments << establishment unless establishment.nil?

        establishment = {
          :owner => clean_name(header[0]),
          :name => clean_name(header[1].empty? ? header[0] : header[1]),
          :address => clean_address(header[2]),
          :type => header[3].empty? ? 'Inconnue' : header[3],
          :infractions => []
        }
      end

      details = table.css('td')
      if details.count == 6
        details = details.map{ |s| s.content.strip }.reject{ |s| s.empty? }

        establishment[:infractions] << {
          :description => details[0],
          :infraction_date => clean_date(details[1]),
          :judgment_date => clean_date(details[2]),
          :amount => details[3].to_i
        }
      end
    end
    establishments
  end

  def month_name
    MONTHS[@month - 1]
  end

  def url
    URI.encode "http://ville.montreal.qc.ca/portal/page?_pageid=2136,2655580&_dad=portal&_schema=PORTAL&mois=#{month_name}&annee=#{year}"
  end

  def filename
    File.join Rails.root, 'data', sprintf("%d_%02d.html", @year, @month)
  end

  def downloaded?
    File.exists? filename
  end

  def content
    downloaded? ? File.read(filename) : open(url).read
  end

  private

  def clean_address(adr)
    adr.mb_chars.delete(",").gsub(/Pointe-aux-Trembles/, "Montréal").gsub(/de la/i, "la").gsub(/(\w+)\./, '\1').titlecase.to_s
  end

  def clean_name(name)
    name.mb_chars.gsub(/&amp;/, '&').titlecase.gsub(/'S/, "'s").to_s
  end

  def clean_date(fr_date)
    fr_date.gsub /(\d+) (\S+) (\d+)/ do |s|
      "#{clean_month($2)} #{$1}, #{$3}"
    end
  end

  def clean_month(fr_month)
    fr_month = fr_month.gsub(/é/, 'e').gsub(/û/, 'u').upcase
    Date::MONTHNAMES[ MONTHS.index(fr_month) + 1 ]
  end
end
