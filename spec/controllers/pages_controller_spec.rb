require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do
  describe "GET 'home'" do
    before { get :home }

    it "should be successful" do
      response.should be_success
    end
  end

  describe "GET 'embed'" do
    before { get :embed }

    it "should be successful" do
      response.should be_success
    end
  end

  describe "GET 'about'" do
    before { get :about }

    it "should be successful" do
      response.should be_success
    end
  end

  describe "GET 'api'" do
    before { get :api }

    it "should be successful" do
      response.should be_success
    end
  end

  describe "GET 'statistics'" do
    before { get :statistics }

    it "should be successful" do
      response.should be_success
    end
  end

end
