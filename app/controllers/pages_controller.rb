require 'enumerable_extensions'

class PagesController < ApplicationController
  caches_page :home, :about, :statistics

  def home
    @infractions = Infraction.includes(:establishment).latest.limit(10)
    @most_infractions = Establishment.by_most_infractions.limit(10)
    @highest_infractions = Establishment.by_highest_infractions.limit(10)
  end

  def about
  end

  def statistics
    @charts = []

    # --- Column charts

    # Collect the number of days between infraction and judgement
    spans = Infraction.all.map do |x|
      (x.judgment_date - x.infraction_date).to_i
    end.sort

    # Collect the frequency of each span
    spans_count = {}
    spans.each do |x|
      spans_count[x] = spans_count[x].to_i + 1
    end

    # Collect statistics about spans
    max       = spans.max
    mean      = spans.mean.round
    deviation = spans.deviation.round
    step      = 60 # 60 days ~ 2 months

    # Deliminate outliers
    first = ([mean - 2 * deviation, 0].max / step.to_f).round * step
    last  = ([mean + 2 * deviation, max].min / step.to_f).round * step

    # Collect data
    chart = Chart.new(I18n.t('charts.days_between_infraction_and_judgment'))
    if first > 0
      chart << {
        :kind => 'outlier',
        :label => "0-#{first - 1}",
        :count => (0..first - 1).to_a.reduce(0) { |sum,x|
          sum + spans_count[x].to_i
        }
      }
    end
    (first..last - 1).to_a.each_slice(step) do |slice|
      chart << {
        :label => "#{slice.first}-#{slice.last}",
        :count => slice.reduce(0) { |sum,x|
          sum + spans_count[x].to_i
        }
      }
    end
    if last < max
      chart << {
        :kind => 'outlier',
        :label => "#{last}-#{max}",
        :count => (last..max).to_a.reduce(0) { |sum,x|
          sum + spans_count[x].to_i
        }
      }
    end
    @charts << chart

    # --- Bar charts

    chart = Chart.new(I18n.t('charts.infractions_count_by_establishment_type'))
    chart + Type.all.map do |type|
      {
        :label => type.name,
        :count => type.establishments.sum(:infractions_count),
        :type => :integer
      }
    end
    chart.sort.first(10)
    @charts << chart

    chart = Chart.new(I18n.t('charts.infractions_amount_by_establishment_type'))
    chart + Type.all.map do |type|
      {
        :label => type.name,
        :count => type.establishments.sum(:infractions_amount),
        :type => :currency
      }
    end
    chart.sort.first(10)
    @charts << chart

    chart = Chart.new(I18n.t('charts.infractions_count_by_infraction_type'))
    types_count = {}
    Infraction.all.each do |infraction|
      types_count[infraction.description] = types_count[infraction.description].to_i + 1
    end
    types_count.each do |label,count|
      chart << {
        :label => label,
        :count => count
      }
    end
    chart.sort.first(10)
    @charts << chart

    chart = Chart.new(I18n.t('charts.infractions_amount_by_infraction_type'))
    types_count = {}
    Infraction.all.each do |infraction|
      types_count[infraction.description] = types_count[infraction.description].to_i + infraction.amount
    end
    types_count.each do |label,count|
      chart << {
        :label => label,
        :count => count
      }
    end
    chart.sort.first(10)
    @charts << chart
  end
end
