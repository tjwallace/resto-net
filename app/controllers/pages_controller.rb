require 'enumerable_extensions'

class PagesController < ApplicationController
  def home
    @infractions = Infraction.includes(:establishment).latest.limit(10)
    @most_infractions = Establishment.by_most_infractions.limit(10)
    @highest_infractions = Establishment.by_highest_infractions.limit(10)
  end

  def about
  end

  def statistics
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
    @max      = spans.max
    mean      = spans.mean.round
    deviation = spans.deviation.round
    @step     = 60 # 60 days ~ 2 months

    # Collect outliers
    @first_cutoff = ([mean - 2 * deviation, 0].max / @step.to_f).round * @step
    @first_value = (0..@first_cutoff - 1).to_a.reduce(0) do |sum,x|
      sum + spans_count[x].to_i
    end

    @last_cutoff  = ([mean + 2 * deviation, @max].min / @step.to_f).round * @step
    if @last_cutoff < @max
      @last_value = (@last_cutoff..@max).to_a.reduce(0) do |sum,x|
        sum + spans_count[x].to_i
      end
    end

    # Collect data
    @bars = []
    (@first_cutoff..@last_cutoff - 1).to_a.each_slice(@step) do |slice|
      @bars << slice.reduce(0) do |sum,x|
        sum + spans_count[x].to_i
      end
    end

    # Needed to set column height
    @max_value = [ @first_value, *@bars, @last_value ].max
  end
end
