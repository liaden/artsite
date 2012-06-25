require 'test_helper'

class TagsControllerTest < ActionController::TestCase
    def setup
        
    end

    test  "should get show" do
        get :show, :id => 1
        assert_response :success
        assert_not_nil assigns(:@tag)
        assert_not_nil assigns(:@artworks)
    end
end

