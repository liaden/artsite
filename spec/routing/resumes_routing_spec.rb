require "spec_helper"

describe ResumesController do
  describe "routing" do

    it "routes to #index" do
      get("/resumes").should route_to("resumes#index")
    end

    it "routes to #new" do
      get("/resumes/new").should route_to("resumes#new")
    end

    it "routes to #show" do
      get("/resumes/1").should route_to("resumes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/resumes/1/edit").should route_to("resumes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/resumes").should route_to("resumes#create")
    end

    it "routes to #update" do
      put("/resumes/1").should route_to("resumes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/resumes/1").should route_to("resumes#destroy", :id => "1")
    end

  end
end
