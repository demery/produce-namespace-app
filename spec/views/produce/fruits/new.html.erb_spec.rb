require 'spec_helper'

describe "produce/fruits/new" do
  before(:each) do
    assign(:produce_fruit, stub_model(Produce::Fruit,
      :kind => "MyString",
      :variety => "MyString",
      :quantity => 1
    ).as_new_record)
  end

  it "renders new fruit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => produce_fruits_path, :method => "post" do
      assert_select "input#produce_fruit_kind", :name => "produce_fruit[kind]"
      assert_select "input#produce_fruit_variety", :name => "produce_fruit[variety]"
      assert_select "input#produce_fruit_quantity", :name => "produce_fruit[quantity]"
    end
  end
end
