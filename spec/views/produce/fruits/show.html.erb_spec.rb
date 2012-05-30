require 'spec_helper'

describe "produce_fruits/show" do
  before(:each) do
    @fruit = assign(:fruit, stub_model(Produce::Fruit,
      :kind => "Kind",
      :variety => "Variety",
      :quantity => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Kind/)
    rendered.should match(/Variety/)
    rendered.should match(/1/)
  end
end
