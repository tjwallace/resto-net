class Yelp
  class YelpError < StandardError; end

  def self.reviews(params)
    response = Yajl::Parser.parse RestClient.get('http://api.yelp.com/business_review_search', {params: {limit: 1, ywsid: ENV['YWSID'], cc: 'CA'}.merge(params)})
    if response['message']['text'] == 'OK'
      response['businesses'].first
    else
      raise YelpError, response['message']['text']
    end
  end

end
