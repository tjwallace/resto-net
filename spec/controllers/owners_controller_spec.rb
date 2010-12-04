require 'spec_helper'

describe OwnersController do

  describe "GET 'index.xml'" do
    before { get :index, :format => :xml }

    it { should respond_with_content_type(:xml) }

    it "should be successful" do
      response.should be_success
    end
  end

  describe "GET 'show.json'" do
    before { get :index, :format => :json }

    it { should respond_with_content_type(:json) }

    it "should be successful" do
      response.should be_success
    end
  end

  describe "GET 'show.xml'" do
    before { get :index, :format => :xml }

    it { should respond_with_content_type(:xml) }

    it "should be successful" do
      response.should be_success
    end
  end

end
