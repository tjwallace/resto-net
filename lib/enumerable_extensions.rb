module Enumerable
  def mean
    self.sum / self.size.to_f
  end

  def median
    array = self.sort
    if self.size.even?
      array[self.size / 2 - 1..self.size / 2].mean
    else
      array[self.size / 2]
    end
  end

  def variance
    mean = self.mean
    1 / self.size.to_f * self.reduce(0) do |sum,i|
      sum + (i - mean) ** 2
    end
  end

  def deviation
    Math.sqrt self.variance
  end
end
