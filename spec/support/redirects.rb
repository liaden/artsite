shared_examples 'unauthorized GET index' do
    it 'redirects' do
        get :index
        response.should redirect_to(redirect_url)
    end
end

shared_examples 'unauthorized GET show' do
    it 'redirects' do
        get :show, :id => item.id
        response.should redirect_to(redirect_url)
    end
end

shared_examples 'unauthorized POST create' do
    it 'redirects' do
        puts attrs.inspect
        post :create, attrs
        response.should redirect_to(redirect_url)
    end

    it 'does not create instance' do
        expect { post :create, attrs }.to_not change{ table.count }
    end
end

shared_examples 'unauthorized GET new' do
    it 'redirects' do
        get :new
        response.should redirect_to(redirect_url)
    end
end

shared_examples 'unauthorized PUT update' do
    it 'redirects' do
        put :update, attrs.merge(:id => item.id)
        response.should redirect_to(redirect_url)
    end

    it 'does not mutate instance' do
        put :update, attrs.merge(:id => item.id)
        item.should == item.reload
    end
end

shared_examples 'unauthorized GET edit' do
    it 'redirects' do
        get :edit, :id => item.id
        response.should redirect_to(redirect_url)
    end
end

shared_examples 'unauthorized DELETE destroy' do
    it 'redirects' do
        get :destroy, :id => item.id
        response.should redirect_to(redirect_url)
    end

    it 'does not delete instance' do
        get :destroy, :id => item.id
        table.find(item.id).should_not be_nil
    end
end

