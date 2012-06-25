require 'spec_helper'

describe "resumes/edit" do
  before(:each) do
    @resume = assign(:resume, stub_model(Resume))
  end

  it "renders the edit resume form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => resumes_path(@resume), :method => "post" do
    end
  end
end
