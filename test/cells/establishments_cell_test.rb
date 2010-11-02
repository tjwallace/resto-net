require 'test_helper'

class EstablishmentsCellTest < Cell::TestCase
  test "most_infractions" do
    invoke :most_infractions
    assert_select "p"
  end
  
  test "highest_infractions" do
    invoke :highest_infractions
    assert_select "p"
  end
  

end
