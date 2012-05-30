require 'spec_helper'

describe "produce/fruits/index" do
  before(:each) do
    assign(:produce_fruits, [
      stub_model(Produce::Fruit,
        :kind => "Kind",
        :variety => "Variety",
        :quantity => 1
      ),
      stub_model(Produce::Fruit,
        :kind => "Kind",
        :variety => "Variety",
        :quantity => 1
      )
    ])
  end

  it "renders a list of produce_fruits" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Kind".to_s, :count => 2
    assert_select "tr>td", :text => "Variety".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
