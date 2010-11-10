class Chart
  attr_accessor :title, :counts

  def initialize(title)
    @title = title
    @reset_max_count = true
    @counts = []
  end

  def << attributes
    @reset_max_count = true
    @counts << Count.new(attributes)
  end

  def + array
    @reset_max_count = true
    @counts += array.map { |attributes| Count.new(attributes) }
  end

  def sort
    @counts.sort! do |a,b|
      b.count <=> a.count
    end
    self
  end

  def first(n)
    @counts = @counts.first(n)
    self
  end

  def max_count
    if @reset_max_count
      @max_count = @counts.map{ |x| x.count }.max
    end
    @max_count
  end
end