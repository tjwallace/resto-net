# encoding: utf-8

namespace :translations do

  desc "French -> English"
  task :fake => :environment do
    I18n.locale = :en
    Infraction.all.each do |i|
      i.update_attribute :description, i.description(:fr)
    end

    Type.all.each do |t|
      t.update_attribute :name, t.name(:fr)
    end
  end

  desc "French -> English"
  task :google => :environment do
    require 'rtranslate'
    I18n.locale = :en

    translations = Hash.new do |h,k|
      sleep 5
      t = Translate.t(k, 'FRENCH', 'ENGLISH')
      puts "Translating: #{k}"
      puts ">> #{t}"
      h[k] = t
    end

    Infraction.includes(:translations).all.each do |i|
      i.update_attribute :description, translations[i.description(:fr)] unless i.description
    end

    Type.includes(:translations).all.each do |t|
      t.update_attribute :name, translations[t.name(:fr)] unless t.name
    end
  end

end
