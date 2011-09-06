require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EstablishmentsController do

  describe "GET 'index'" do
    before { get :index }

    it "should be successful" do
      response.should be_success
    end
  end

  describe "GET 'index.json'" do
    before { get :index, :format => :json }

    it { should respond_with_content_type(:json) }

    it "should be successful" do
      response.should be_success
    end
  end

  describe "GET 'index.xml'" do
    before { get :index, :format => :xml }

    it { should respond_with_content_type(:xml) }

    it "should be successful" do
      response.should be_success
    end
  end

end
