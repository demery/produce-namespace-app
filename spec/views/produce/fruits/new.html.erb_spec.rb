require 'spec_helper'

describe "produce_fruits/new" do
  before(:each) do
    assign(:fruit, stub_model(Produce::Fruit,
      :kind => "MyString",
      :variety => "MyString",
      :quantity => 1
    ).as_new_record)
  end

  it "renders new fruit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => produce_fruits_path, :method => "post" do
      assert_select "input#fruit_kind", :name => "fruit[kind]"
      assert_select "input#fruit_variety", :name => "fruit[variety]"
      assert_select "input#fruit_quantity", :name => "fruit[quantity]"
    end
  end
end
