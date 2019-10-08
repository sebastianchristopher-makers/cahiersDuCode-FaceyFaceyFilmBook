feature 'landing page' do

  scenario 'landing page goes to correct path' do
    visit('/')
    expect(page).to have_current_path('/')
  end

  scenario 'landing page displays sign in information' do
    visit('/')
    expect(page).to have_content("Sign In")
  end

  scenario 'landing page displays sign in information' do
    visit('/')
    expect(page).to have_content("Sign Up")
  end
end
