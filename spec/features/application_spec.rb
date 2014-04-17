require 'spec_helper'
require 'capybara/rspec'

Capybara.app = Application

feature 'Homepage' do

  before :each do
    DB[:users].delete
  end

  scenario 'User can Register and logout and login again' do
    visit '/'
    register_user("bob@gmail.com", "1234")
    expect(page).to have_content "Welcome, bob@gmail.com"
    click_on "Logout"
    login("bob@gmail.com", "1234")
    expect(page).to have_content ("Welcome, bob@gmail.com")
  end

  scenario 'User cannot login if their email does not exist' do
    visit '/'
    register_user("sara@yahoo.com", "pass")
    expect(page).to have_content "Welcome, sara@yahoo.com"
    click_on "Logout"
    expect(page).to_not have_content("Welcome, sara@yahoo.com")
    login("jim@yahoo.com", "pass")
    expect(page).to have_content "Email/Password is invalid"
    end

  scenario 'User cannot sign in with an invalid email / password' do
    visit '/'
    register_user("dave@yahoo.com", "pass")
    expect(page).to have_content "Welcome, dave@yahoo.com"
    click_on "Logout"
    expect(page).to_not have_content("Welcome, dave@yahoo.com")
    login("dave@yahoo.com", "7890")
    expect(page).to have_content "Email/Password is invalid"
  end

  scenario 'User can see list of users if he/she is an admin' do
    visit '/'
    hashed_password = BCrypt::Password.create("whatever")
    DB[:users].insert(email: "admin@yahoo.com", password: hashed_password, admin: true)
    login("admin@yahoo.com", "whatever")
    click_on "View all users"
    expect(page).to have_content("Users")
  end

  scenario 'User can not see list of users if he/she is not an admin' do
    visit '/'
    register_user("admin@yahoo.com", "pass")
    expect(page).to_not have_content("View all users")
    visit '/users'
    expect(page).to have_content("You do not have access, get out!")
  end

  scenario 'User cannot register if their password is less than 3 characters' do
    visit '/'
    register_user("short@yahoo.com", "12")
    expect(page).to have_content("Password cannot be less than 3 characters")
  end

  def register_user(email, password)
    click_on "Register"
    fill_in "email", with: email
    fill_in "password", with: password
    click_on "Register"
  end

  def login(email, password)
    click_on "Login"
    fill_in "email", with: email
    fill_in "password", with: password
    click_on "Login"
  end
end


