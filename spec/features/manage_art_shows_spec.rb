describe "manage art shows" do
  context 'as admin' do
    describe 'show page' do
      it 'shows edit button' 
      it 'works with best in place'
      it 'handles best in place dates'
      it 'address links to google maps'
      it 'best in place edits address with edit link'
    end
  end

  context 'as guest' do
    describe 'show page' do
      it 'does not show edit link'
      it 'does not enable best in place editing'
      it 'the address links to google maps'
    end
  end
  
  describe 'schedule of upcoming events' do
    it 'lists next three events'
    it 'has a table with all events'
  end
end
