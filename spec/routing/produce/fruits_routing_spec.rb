require "spec_helper"

describe Produce::FruitsController do
  describe "routing" do

    it "routes to #index" do
      get("/produce/fruits").should route_to("produce/fruits#index")
    end

    it "routes to #new" do
      get("/produce/fruits/new").should route_to("produce/fruits#new")
    end

    it "routes to #show" do
      get("/produce/fruits/1").should route_to("produce/fruits#show", :id => "1")
    end

    it "routes to #edit" do
      get("/produce/fruits/1/edit").should route_to("produce/fruits#edit", :id => "1")
    end

    it "routes to #create" do
      post("/produce/fruits").should route_to("produce/fruits#create")
    end

    it "routes to #update" do
      put("/produce/fruits/1").should route_to("produce/fruits#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/produce/fruits/1").should route_to("produce/fruits#destroy", :id => "1")
    end

  end
end
