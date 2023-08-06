include Warden::Test::Helpers
Warden.test_mode!

feature 'Order listing', :devise, :js do
  let(:user) { create(:user) }
  let!(:orders) { create_list(:order, 10) }

  before do
    login_as(user, :scope => :user)
  end

  after do
    Warden.test_reset!
  end

  scenario 'user can view orders' do
    visit root_path
    click_link "Order listing"

    expect(page).to have_selector ".orders-table"
    expect(page).to have_selector ".orders-table tr", count: 11
    expect(page).to have_selector ".fulfil-btn", count: 10


    expect(page).to have_text orders[0].customer_name
    expect(page).to have_text orders[0].quantity
    expect(page).to have_text orders[0].item
  end

  scenario 'user can not view "fulfill order" button if order is already fulfilled' do 
    orders[0].update(fulfilled: true)
    visit root_path
    click_link "Order listing"

    expect(page).to have_selector ".fulfil-btn", count: 9
  end
end
