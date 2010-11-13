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

  def column_chart(title, values, step)
    # Collect the frequency of each value
    counts = {}
    values.each do |x|
      counts[x] = counts[x].to_i + 1
    end

    # Collect statistics about values
    max       = values.max
    mean      = values.mean.round
    deviation = values.deviation.round

    # Deliminate outliers
    first = ([mean - 2 * deviation, 0].max / step.to_f).round * step
    last  = ([mean + 2 * deviation, max].min / step.to_f).round * step

    # Create chart
    chart = Chart.new(title)
    if first > 0
      chart << {
        :kind => 'outlier',
        :label => "0-#{first - 1}",
        :count => (0..first - 1).to_a.reduce(0) { |sum,x|
          sum + counts[x].to_i
        }
      }
    end
    (first..last - 1).to_a.each_slice(step) do |slice|
      chart << {
        :label => "#{slice.first}-#{slice.last}",
        :count => slice.reduce(0) { |sum,x|
          sum + counts[x].to_i
        }
      }
    end
    if last < max
      chart << {
        :kind => 'outlier',
        :label => "#{last}-#{max}",
        :count => (last..max).to_a.reduce(0) { |sum,x|
          sum + counts[x].to_i
        }
      }
    end
    chart
  end

  def statistics
    @charts = []

    # Column charts

    @charts << column_chart(I18n.t('charts.days_between_infraction_and_judgment'), Infraction.all.map { |x|
      (x.judgment_date - x.infraction_date).to_i
    }.sort, 60) # 60 days ~ 2 months

    @charts << column_chart(I18n.t('charts.infraction_amounts'), Infraction.all.map(&:amount).sort, 500)

    # Bar charts

    chart = Chart.new(I18n.t('charts.infractions_count_by_establishment_type'))
    chart + Type.includes(:establishments, :translations).map do |type|
      {
        :label => type.name,
        :count => type.establishments.reduce(0) { |memo,x|
          memo + x.infractions_count
        },
        :type => :integer
      }
    end
    chart.sort.first(10)
    @charts << chart

    chart = Chart.new(I18n.t('charts.infractions_amount_by_establishment_type'))
    chart + Type.includes(:establishments, :translations).map do |type|
      {
        :label => type.name,
        :count => type.establishments.reduce(0) { |memo,x|
          memo + x.infractions_amount
        },
        :type => :currency
      }
    end
    chart.sort.first(10)
    @charts << chart

    chart = Chart.new(I18n.t('charts.infractions_count_by_infraction_type'))
    types_count = {}
    Infraction.includes(:translations).each do |infraction|
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

=begin
    chart = Chart.new(I18n.t('charts.infractions_amount_by_infraction_type'))
    types_count = {}
    Infraction.includes(:translations).each do |infraction|
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
=end
  end
end
