require 'spec_helper'

describe IdeasController do

    context  'as admin' do
        before(:each) { login :admin }
    end

end
