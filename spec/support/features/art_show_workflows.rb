module Features
  module ArtShowWorkflows
    def fill_in_form(art_show = nil)
      art_show = FactoryGirl.build(:show) unless art_show
  
      fill_in 'show_name', :with => art_show.name
      fill_in 'show_description', :with => art_show.description
      fill_in 'show_date', :with => I18n.localize(art_show.date)
      fill_in 'show_address', :with => art_show.address
      choose art_show.show_type
    end
  
    def submit_art_show_form
      click_button('Create')
    end
  end
end
