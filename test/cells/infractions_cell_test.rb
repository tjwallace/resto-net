require 'test_helper'

class InfractionsCellTest < Cell::TestCase
  test "latest" do
    invoke :latest
    assert_select "p"
  end
  

end
