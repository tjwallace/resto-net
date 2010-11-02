class EstablishmentsCell < Cell::Rails

  def most_infractions
    @establishments = Establishment.by_most_infractions.limit(10)
    render
  end

  def highest_infractions
    @establishments = Establishment.by_highest_infractions.limit(10)
    render
  end

end
