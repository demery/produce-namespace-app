require 'spec_helper'

module Produce
  describe Fruit do
    def valid_attributes
      @valid_attributes ||= {
        kind: "apple",
        variety: "Gala",
        quantity: 3
      }
    end

    # ------------------------------------------------------------
    # initialization
    # ------------------------------------------------------------
    context "(initialization)" do
      it "is valid" do
        Produce::Fruit.new(valid_attributes).should be_valid
      end

      it "creates a Fruit" do
        Produce::Fruit.create!(valid_attributes).should be_a(Fruit)
      end

      it "has a factory" do
        FactoryGirl.create(:produce_fruit).should be_a(Fruit)
      end
    end # context "(initialization)"

    # ------------------------------------------------------------
    # attributes
    # ------------------------------------------------------------
    context "(attributes)" do
      it "has a kind" do
        Produce::Fruit.new(kind: (kind = "apple")).kind.should eq(kind)
      end

      it "has a variety" do
        Produce::Fruit.new(variety: (variety = "gala")).variety.should eq(variety)
      end

      it "has a quantity" do
        Produce::Fruit.new(quantity: (quantity = 3)).quantity.should eq(quantity)
      end
    end # context "(attributes)"

    # ------------------------------------------------------------
    # validations
    # ------------------------------------------------------------
    context "(validations)" do
      it "requires kind" do
        Produce::Fruit.new(kind: nil).should have(1).error_on(:kind)
      end

      it "requires variety" do
        Produce::Fruit .new(variety: nil).should have(1).error_on(:variety)
      end

      it "requires a kind be unique" do
        Produce::Fruit.create!(valid_attributes)
        Produce::Fruit.new(valid_attributes).should have(1).error_on(:kind)
      end
    end # context "(validations)"
  end
end
