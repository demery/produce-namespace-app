require "spec_helper"

describe Produce::FruitsController do
  describe "routing" do

    it "routes to #index" do
      get("/produce_fruits").should route_to("produce_fruits#index")
    end

    it "routes to #new" do
      get("/produce_fruits/new").should route_to("produce_fruits#new")
    end

    it "routes to #show" do
      get("/produce_fruits/1").should route_to("produce_fruits#show", :id => "1")
    end

    it "routes to #edit" do
      get("/produce_fruits/1/edit").should route_to("produce_fruits#edit", :id => "1")
    end

    it "routes to #create" do
      post("/produce_fruits").should route_to("produce_fruits#create")
    end

    it "routes to #update" do
      put("/produce_fruits/1").should route_to("produce_fruits#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/produce_fruits/1").should route_to("produce_fruits#destroy", :id => "1")
    end

  end
end
