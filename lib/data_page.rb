# encoding: utf-8
require 'nokogiri'
require 'open-uri'

class DataPage
  MONTHS = %w(janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre)

  def initialize(year = nil, verbose = true)
    @year = year || Date.today.year
    @verbose = verbose
  end

  def log(msg, method = :puts)
    send(method, msg) if @verbose
  end

  def scan(source = nil)
    log "Importing infractions for #{@year}"

    latest_judgment_date = Infraction.order("judgment_date DESC").first.judgment_date rescue Date.new

    Nokogiri.XML(content(source), nil, 'utf-8').xpath('//contrevenant').each do |inf|
      Establishment.transaction do
        owner = Owner.find_or_create_by_name get_name(inf, 'proprietaire')

        type_name = inf.at_xpath('categorie').text rescue 'Inconnue'
        type = Type.find_or_create_by_name type_name

        establishment = Establishment.find_or_create_by_name_and_address get_name(inf, 'etablissement'), get_address(inf, 'adresse'),
          :type_id => type.id

        infraction = establishment.infractions.build(
          :description => inf.at_xpath('description').text,
          :infraction_date => get_date(inf, 'date_infraction'),
          :judgment_date => get_date(inf, 'date_jugement'),
          :amount => inf.at_xpath('montant').text.to_i,
          :owner_id => owner.id
        )

        if infraction.judgment_date > latest_judgment_date
          infraction.save!
          log ".", :print
        else
          log "*", :print
        end
      end
    end

    log " Done"
  end

  def url
    URI.encode "http://ville.montreal.qc.ca/pls/portal/portalcon.contrevenants_recherche?p_mot_recherche=,tous,#{@year}"
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
    inf.at_xpath(xpath).text.mb_chars.gsub(/&amp;/, '&').titlecase.gsub(/'S/, "'s").to_s rescue "Unknown"
  end

  def get_address(inf, xpath)
    inf.at_xpath(xpath).text.mb_chars.delete(",").gsub(/de la/i, "la").gsub(/(\w+)\./, '\1').titlecase.to_s
  end

  def get_date(inf, xpath)
    d = inf.at_xpath(xpath).text.mb_chars.scan(/(\d+) (\S+) (\d+)/).flatten
    month = Date::MONTHNAMES[ MONTHS.index(d[1].gsub(/é/, 'e').gsub(/û/, 'u')) + 1 ]
    "#{month} #{d[0]}, #{d[2]}"
  end
end
