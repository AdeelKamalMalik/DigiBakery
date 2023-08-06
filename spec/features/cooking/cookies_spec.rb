feature 'Cooking cookies' do
  scenario 'Cooking a single cookie' do
    user = create_and_signin
    oven = user.ovens.first
    ActiveJob::Base.queue_adapter = :test

    visit oven_path(oven)

    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your Cookie is Ready'

    click_link_or_button 'Prepare Cookie'
    fill_in 'Fillings', with: 'Chocolate Chip'
    fill_in 'no_of_cookies', with: 1

    expect {
      click_button 'Mix and bake'
    }.to have_enqueued_job(PrepareCookieJob)

    expect(current_path).to eq(oven_path(oven))
    expect(page).to have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your Cookie is Ready'

    PrepareCookieJob.perform_now(oven.cookies.last)
    visit oven_path(oven)
    
    expect(page).to have_content 'Your Cookie is Ready'
    click_button 'Retrieve Cookie'
    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your Cookie is Ready'

    visit root_path
    within '.store-inventory' do
      expect(page).to have_content '1 Cookie'
    end

    visit root_path
  end

  scenario 'Trying to prepare a batch of cookies' do
    user = create_and_signin
    oven = user.ovens.first

    oven = create(:oven, user: user)
    visit oven_path(oven)

    click_link_or_button 'Prepare Cookie'
    fill_in 'Fillings', with: 'Chocolate Chip'
    fill_in 'no_of_cookies', with: 4
    click_button 'Mix and bake'

    expect(current_path).to eq(oven_path(oven))
    expect(page).to have_content 'Chocolate Chip'
  end
end
