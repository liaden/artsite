require 'spec_helper'

describe StatusController do
  render_views

  it 'has navbar' do
    get :index
    expect(response.body).to have_content('Gallery')
  end

  it 'is ok' do
    get :index
    expect(response.body).to have_content('Ok')
  end
end
