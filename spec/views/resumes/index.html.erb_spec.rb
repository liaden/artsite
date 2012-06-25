require 'spec_helper'

describe "resumes/index" do
  before(:each) do
    assign(:resumes, [
      stub_model(Resume),
      stub_model(Resume)
    ])
  end

  it "renders a list of resumes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
