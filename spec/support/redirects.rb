def make_hash(instance_var, standard_hash)
  (instance_var || {}).merge(standard_hash)
end


shared_examples 'unauthorized GET index' do
  it 'redirects' do
    get :index, make_hash(@ids, {})
    response.should redirect_to(redirect_url)
  end
end

shared_examples 'unauthorized GET show' do
  it 'redirects' do
    get :show, make_hash(@ids, :id => item.id)
    response.should redirect_to(redirect_url)
  end
end

shared_examples 'unauthorized POST create' do
    let (:table_name) { table.name.to_sym }

  it 'redirects' do
    post :create, make_hash(@ids, table_name => attrs)
    response.should redirect_to(redirect_url)
  end

  it 'does not create instance' do
    expect { 
      post :create, make_hash(@ids, table_name =>attrs)
    }.to_not change{ table.count }
  end
end

shared_examples 'unauthorized GET new' do
  it 'redirects' do
    get :new, make_hash(@ids, {})
    response.should redirect_to(redirect_url)
  end
end

shared_examples 'unauthorized PUT update' do
  let (:table_name) { table.name.to_sym }

  it 'redirects' do
    put :update, make_hash(@ids, table_name => attrs, :id => item.id)
    response.should redirect_to(redirect_url)
  end

  it 'does not mutate instance' do
    put :update, make_hash(@ids, table_name => attrs, :id => item.id)
    item.should == item.reload
  end
end

shared_examples 'unauthorized GET edit' do
  it 'redirects' do
    get :edit, make_hash(@ids, :id => item.id)
    response.should redirect_to(redirect_url)
  end
end

shared_examples 'unauthorized DELETE destroy' do
  it 'redirects' do
    get :destroy, make_hash(@ids, :id => item.id)
    response.should redirect_to(redirect_url)
  end

  it 'does not delete instance' do
    get :destroy, make_hash(@ids, :id => item.id)
    table.find(item.id).should_not be_nil
  end
end

