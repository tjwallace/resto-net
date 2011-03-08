# encoding: utf-8
require 'nokogiri'
require 'open-uri'

class DataPage
  MONTHS = %w(JANVIER FEVRIER MARS AVRIL MAI JUIN JUILLET AOUT SEPTEMBRE OCTOBRE NOVEMBRE DECEMBRE)

  attr_reader :year

  def initialize(year = nil)
    @year = year || Date.today.year
  end

  def scan
    puts "Scanning #{year}"
    Nokogiri.XML(content, nil, 'utf-8').xpath('//contrevenant').each do |inf|
      Establishment.transaction do
        owner = Owner.find_or_create_by_name get_name(inf, 'proprietaire')

        type_name = inf.at_xpath('categorie').text rescue 'Inconnue'
        type = Type.find_or_create_by_name type_name

        establishment = Establishment.find_or_create_by_name_and_address get_name(inf, 'etablissement'), get_address(inf, 'adresse'),
          :type_id => type.id

        establishment.infractions.create(
          :description => inf.at_xpath('description').text,
          :infraction_date => get_date(inf, 'date_infraction'),
          :judgment_date => get_date(inf, 'date_jugement'),
          :amount => inf.at_xpath('montant').text.to_i,
          :owner_id => owner.id
        )
      end
      print "."
    end
    puts " DONE"
  end

  def url
    URI.encode "http://ville.montreal.qc.ca/pls/portal/portalcon.contrevenants_recherche?p_mot_recherche=,tous,#{year}"
  end

  def filename
    File.join Rails.root, 'data', sprintf("%d.xml", @year)
  end

  def downloaded?
    File.exists? filename
  end

  def content(source = nil)
    case source
    when :local
      File.read filename
    when :remote
      open(url).read
    else
      downloaded? ? File.read(filename) : open(url).read
    end
  end

  private

  def get_name(inf, xpath)
    inf.at_xpath(xpath).text.mb_chars.gsub(/&amp;/, '&').titlecase.gsub(/'S/, "'s").to_s
  end

  def get_address(inf, xpath)
    inf.at_xpath(xpath).text.mb_chars.delete(",").gsub(/de la/i, "la").gsub(/(\w+)\./, '\1').titlecase.to_s
  end

  def get_date(inf, xpath)
    d = inf.at_xpath(xpath).text.mb_chars.scan(/(\d+) (\S+) (\d+)/).flatten
    "#{clean_month(d[1])} #{d[0]}, #{d[2]}"
  end

  def clean_month(fr_month)
    fr_month = fr_month.gsub(/é/, 'e').gsub(/û/, 'u').upcase
    Date::MONTHNAMES[ MONTHS.index(fr_month.to_s) + 1 ]
  end
end
