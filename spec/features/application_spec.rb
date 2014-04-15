require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'Homepage' do
  scenario 'User can Register and logout' do
    visit '/'
    click_on "Register"
    fill_in "email", with: "bob@gmail.com"
    fill_in "password", with: "1234"
    click_on "Register"
    expect(page).to have_content "Welcome, bob@gmail.com"
    click_on "Logout"
    expect(page).to_not have_content("Welcome, bob@gmail.com")
    click_on "Login"
    fill_in "email", with: "bob@gmail.com"
    fill_in "password", with: "kaylee"
    click_on "Login"
    expect(page).to have_content "Welcome, bob@gmail.com"
  end
end


