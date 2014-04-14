require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'Homepage' do
  scenario 'Shows the welcome message' do
    visit '/'

    expect(page).to have_content 'Welcome'
  end

  scenario 'User can Register' do
    visit '/'
    click_on "Register"
    fill_in "email", with: "bob@gmail.com"
    fill_in "password", with: "1234"
    click_on "Register"
    expect(page). to have_content "Welcome, bob@gmail.com"
  end
end

