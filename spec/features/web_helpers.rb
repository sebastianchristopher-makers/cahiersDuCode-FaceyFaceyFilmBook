def sign_up
  visit '/'
  click_button 'Sign Up'
  fill_in(:email, with: 'example@example.com')
  fill_in(:password, with: 'password1234')
  click_button 'Sign in'
end
