class InfractionsCell < Cell::Rails

  def latest
    @infractions = Infraction.latest.limit(10)
    render
  end

end
