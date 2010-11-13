# encoding: utf-8

namespace :translations do

  desc "French -> English"
  task :fake => :environment do
    I18n.locale = :en
    Infraction.all.each do |i|
      i.update_attributes(:description => i.description(:fr)) 
    end

    Type.all.each do |t|
      t.update_attributes(:name => t.name(:fr))
    end
  end

  desc "French -> English"
  task :google => :environment do
    require 'rtranslate'
    I18n.locale = :en

    translations = Hash.new do |h,k|
      sleep 5.0
      t = Translate.t(k, 'FRENCH', 'ENGLISH')
      puts "Translating: #{k}"
      puts ">> #{t}"
      h[k] = t
    end

    Infraction.includes(:translations).all.each do |i|
      i.update_attributes(:description => translations[i.description(:fr)])
    end

    Type.includes(:translations).all.each do |t|
      t.update_attributes(:name => translations[t.name(:fr)])
    end
  end

end
