require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'Homepage' do

  before :each do
    DB[:users].delete
  end

  scenario 'User can Register and logout and login again' do
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
    fill_in "password", with: "1234"
    click_on "Login"
    expect(page).to have_content ("Welcome, bob@gmail.com")
  end

  scenario 'User cannot login if their email does not exist' do
    visit '/'
    click_on "Register"
    fill_in "email", with: "sara@yahoo.com"
    fill_in "password", with: "pass"
    click_on "Register"
    expect(page).to have_content "Welcome, sara@yahoo.com"
    click_on "Logout"
    expect(page).to_not have_content("Welcome, sara@yahoo.com")
    click_on "Login"
    fill_in "email", with: "jim@yahoo.com"
    fill_in "password", with: "pass"
    click_on "Login"
    expect(page).to have_content "Email/Password is invalid"
    end

  scenario 'User cannot sign in with an invalid email / password' do
    visit '/'
    click_on "Register"
    fill_in "email", with: "dave@yahoo.com"
    fill_in "password", with: "pass"
    click_on "Register"
    expect(page).to have_content "Welcome, dave@yahoo.com"
    click_on "Logout"
    expect(page).to_not have_content("Welcome, dave@yahoo.com")
    click_on "Login"
    fill_in "email", with: "dave@yahoo.com"
    fill_in "password", with: "7890"
    click_on "Login"
    expect(page).to have_content "Email/Password is invalid"
  end

  scenario 'User can see list of users if he/she is an admin' do
    visit '/'
    hashed_password = BCrypt::Password.create("whatever")
    DB[:users].insert(email: "admin@yahoo.com", password: hashed_password, admin: true)
    click_on "Login"
    fill_in "email", with: "admin@yahoo.com"
    fill_in "password", with: "whatever"
    click_on "Login"
    click_on "View all users"
    expect(page).to have_content("Users")
  end

  scenario 'User can not see list of users if he/she is not an admin' do
    visit '/'
    click_on "Register"
    fill_in "email", with: "admin@yahoo.com"
    fill_in "password", with: "pass"
    click_on "Register"
    expect(page).to_not have_content("View all users")
  end
end


