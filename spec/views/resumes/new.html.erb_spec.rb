require 'spec_helper'

describe "resumes/new" do
  before(:each) do
    assign(:resume, stub_model(Resume).as_new_record)
  end

  it "renders new resume form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => resumes_path, :method => "post" do
    end
  end
end
