require 'spec_helper'

describe SessionsController, :type => :request do
  render_views

  let(:user){ Fabricate(:user) }

  it 'should handle invalid login' do
    visit login_path

    email = Faker::Internet.email
    passwd = Faker::HipsterIpsum.word

    within('#login') do
      fill_in 'email', :with => email
      fill_in 'password', :with => passwd
    end

    click_button 'submit_login'

    page.should have_css('#notifications .alert-box.alert')
  end

  it 'should handle login for inactive accounts' do
    visit login_path

    within('#login') do
      fill_in 'email', :with => user.email
      fill_in 'password', :with => 'secret'
    end

    click_button 'submit_login'

    page.should have_css('#notifications .alert-box')
  end

  it 'should handle login for active accounts' do
    user.activate!

    visit login_path

    within('#login') do
      fill_in 'email', :with => user.email
      fill_in 'password', :with => 'secret'
    end

    click_button 'submit_login'

    page.status_code.should eq(200)
    page.should have_css('#notifications .alert-box.notice')
  end

  it 'should handle logout' do
    user.activate!
    login_user(user.email, 'secret')

    page.should_not have_css('#login')
    visit logout_path
    page.should have_css('#login')
  end

end