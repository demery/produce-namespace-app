require 'spec_helper'

describe "produce_fruits/edit" do
  before(:each) do
    @fruit = assign(:fruit, stub_model(Produce::Fruit,
      :kind => "MyString",
      :variety => "MyString",
      :quantity => 1
    ))
  end

  it "renders the edit fruit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => produce_fruits_path(@fruit), :method => "post" do
      assert_select "input#fruit_kind", :name => "fruit[kind]"
      assert_select "input#fruit_variety", :name => "fruit[variety]"
      assert_select "input#fruit_quantity", :name => "fruit[quantity]"
    end
  end
end
