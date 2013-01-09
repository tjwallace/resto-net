# coding: utf-8
require 'fileutils'
require 'open-uri'
require 'unicode_utils/titlecase'

class DataFile
  def initialize(verbose = true)
    @verbose = verbose
  end

  def log(msg, method = :puts)
    send(method, msg) if @verbose
  end

  def scan(source = nil)
    latest_judgment_date = Infraction.order('judgment_date DESC').first.judgment_date rescue Date.new

    log 'Importing infractions'
    Nokogiri::XML(content(source), nil, 'utf-8').xpath('//contrevenant').each do |xml|
      Establishment.transaction do
        owner = Owner.find_or_create_by_name get_name(xml, 'proprietaire')
        type = Type.find_or_create_by_name xml.at_xpath('categorie').text.strip
        establishment = Establishment.find_or_create_by_name_and_address_and_city(
          get_name(xml, 'etablissement', owner.name),
          xml.at_xpath('adresse').text.strip,
          xml.at_xpath('ville').text.strip,
          :type_id => type.id)
        infraction = establishment.infractions.build(
          :description => xml.at_xpath('description').text.strip,
          :infraction_date => get_date(xml, 'date_infraction'),
          :judgment_date => get_date(xml, 'date_jugement'),
          :amount => xml.at_xpath('montant').text.strip.to_i,
          :owner_id => owner.id)
        if infraction.judgment_date > latest_judgment_date
          infraction.save!
          log ".", :print
        else
          log "*", :print
        end
      end
    end
    log "Done"
  end

  def url
    URI.encode 'http://depot.ville.montreal.qc.ca/inspection-aliments-contrevenants/data.xml'
  end

  def filename
    File.join Rails.root, 'data', 'data.xml'
  end

  def downloaded?
    File.exists? filename
  end

  def download
    if downloaded?
      log "Skipping #{filename}"
    else
      download!
    end
  end

  def download!
    FileUtils.mkdir_p File.join(Rails.root, 'data')
    log "Downloading #{filename}"
    File.open filename, 'wb' do |f|
      f.write content(:remote)
    end
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

  # Names are originally in all caps.
  def get_name(xml, xpath, fallback = "Unknown")
    UnicodeUtils.titlecase(xml.at_xpath(xpath).text.gsub(/&amp;/, '&'), :fr).gsub(/'S/, "'s").strip
  end

  def get_date(xml, xpath)
    I18n.locale = :fr
    parts = xml.at_xpath(xpath).text.match /\A(\d+) (\p{L}+) (\d+)\z/
    "#{parts[3]}-#{I18n.t('date.month_names').index parts[2]}-#{parts[1]}"
  end
end
