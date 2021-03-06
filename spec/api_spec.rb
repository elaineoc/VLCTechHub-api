require 'spec_helper'
require 'time'
require_relative '../api'

describe VLCTechHub::API do
  def app
    VLCTechHub::API
  end

  describe "GET /v0/events/upcoming" do
    it "returns a list of future events" do
      request_time = Time.now.utc
      get "/v0/events/upcoming"
      last_response.status.should == 200
      JSON.parse(last_response.body).select { |e| e['date'] < request_time }.should == [] if  JSON.parse(last_response.body) != []
    end
  end
  describe "GET /v0/events/past" do
    it "returns a list of past events" do
      request_time = Time.now.utc
      get "/v0/events/past"
      last_response.status.should == 200
      JSON.parse(last_response.body).select { |e| e['date'] >= request_time }.should == [] if  JSON.parse(last_response.body) != []
    end
  end
  describe "GET /v0/events/year/month" do
    it "returns a list of events for that year and month" do
      month = DateTime.new(2014, 02, 01)
      next_month = DateTime.new(2014, 03, 01)
      get "/v0/events/2014/02"
      last_response.status.should == 200
      JSON.parse(last_response.body).should_not == []
      JSON.parse(last_response.body).select { |e| (e['date'] < month  || e['date'] > next_month) }.should == [] 
    end
  end
  describe "GET /v0/events/:id" do
    it "returns an event by id" do
      get "/v0/events/52efbf75a1aac70200000001"
      last_response.status.should == 200
      last_response.body.should_not == {}
    end
  end
end
