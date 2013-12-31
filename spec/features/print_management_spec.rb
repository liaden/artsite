require 'spec_helper'

describe 'Manage Prints' do
    before(:each) { mock_paperclip_post_process }
    let(:artwork) { FactoryGirl.create(:artwork) }

    context 'as admin' do
        before(:each) { login_step :admin }

        context 'control page' do
            it 'lists all prints' do
                FactoryGirl.create(:canvas, :artwork => artwork, :dimensions => '10x10')
                FactoryGirl.create(:original, :artwork => artwork, :dimensions => '10x10')
                FactoryGirl.create(:print, :artwork => artwork, :dimensions => '10x10')

                visit artwork_prints_path(artwork)

                within('#photopaper-prints') { page.should have_content('10x10') }
                within('#canvas-prints') { page.should have_content('10x10') }
                within('#original-artwork') { page.should have_content('10x10') }
            end

            it 'does not allow creation of original when one exists' do
                FactoryGirl.create(:original, :artwork => artwork)

                visit artwork_prints_path(artwork)

                page.should_not have_content('Add original')
            end

            it 'provides links to print creation' do
                visit artwork_prints_path(artwork)
                
                page.should have_content('Add original')
                page.should have_content('Add new canvas')
                page.should have_content('Add new photopaper')
            end

        end

        context 'editing print' do
            let(:print) { FactoryGirl.create(:print, :artwork => artwork) }

            it 'shows validation errors' do
                visit edit_artwork_print_path(artwork, print)
                fill_in :print_price, :with => "-1"
                click_button 'Save'
                page.should have_content('Error')
                within('#model-errors') do
                    all('li').should have(1).items
                end
            end

            it 'saves the changes' do
                visit edit_artwork_print_path(artwork, print)
                fill_in :print_price, :with => "7.5"
                click_button 'Save'
            end
        end

        context 'new print on artwork' do
            it 'shows validation errors' do
                visit canvas_artwork_prints_path(artwork)

                fill_in :print_dimensions, :with => '10x10'
                fill_in :print_price, :with => '-10.00'
                fill_in :print_inventory_count, :with => 5

                select :small, :from => :print_size_name

                click_button 'Save'

                page.should have_content('Error')
                within('#model-errors') do
                    all('li').should have(1).item
                end
            end

            it 'adds a new photopaper to prints' do
                visit artwork_prints_path(artwork)
                click_link "Add new photopaper"

                fill_in :print_dimensions, :with => '10x10'
                fill_in :print_price, :with => '10.00'
                fill_in :print_inventory_count, :with => 5

                select :small, :from => :print_size_name

                click_button 'Save'

                page.should_not have_content('Error')
                within('#photopaper-prints') do
                    page.should have_content('10x10')
                end
            end
                
            it 'adds a new canvas to prints' do
                visit artwork_prints_path(artwork)

                click_link "Add new canvas"

                fill_in :print_dimensions, :with => '10x10'
                fill_in :print_price, :with => '10.00'
                fill_in :print_inventory_count, :with => 5

                select :small, :from => :print_size_name

                click_button 'Save'

                page.should_not have_content('Error')
                within('#canvas-prints') do
                    page.should have_content('10x10')
                end
            end
            it 'adds a new original' do
                visit artwork_prints_path(artwork)
                click_link "Add original"

                fill_in :print_dimensions, :with => '10x10'
                fill_in :print_price, :with => '10.00'
                choose('print_is_sold_out_false')

                click_button 'Save'

                page.should_not have_content('Error')
                within('#original-artwork') do
                    page.should have_content('10x10')
                end

            end

            it 'does not show a sold out original as purchasable' 
        end
    end
end
