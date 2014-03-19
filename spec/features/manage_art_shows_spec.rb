describe "manage art shows" do
  context 'as admin' do
    before(:each) { login_step :admin }
    before(:each) { FactoryGirl.create(:artwork) }

    let(:show) { FactoryGirl.create(:show) }

    describe 'show page' do
      before(:each) { visit show_path(show) }

      it 'shows edit button' do
        page.should have_css('#edit-address')
      end

      it 'works with best in place'
      it 'handles best in place dates'
      it 'address links to google maps'
        
      it 'best in place edits address with edit link' do
      end
    end
  end

  context 'as guest' do
    describe 'show page' do
      it 'does not show edit link' do
        page.should_not have_css('#edit-address')
      end

      it 'does not enable best in place editing' do
        page.should_not have_css('.best_in_place')
      end

      it 'the address links to google maps'
    end
  end
  
  describe 'schedule of upcoming events' do
    it 'lists next three events'
    it 'has a table with all events'
  end
end
