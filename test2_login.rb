###
# file: test2_login.rb
# run from CLI: rspec test2_login.rb

require "selenium-webdriver"
require "rspec"

describe "Logging in" do
  it "authenticates user and proceeds to next page" do
    #xit  to disable
    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to 'https://lovevery-test.com/account/login'

    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { driver.find_element(id: 'email').displayed? }


    driver.find_element(id: 'email').send_keys('TestOctB2020@mailinator.com')
    driver.find_element(css: 'input[name="password"]').send_keys('Tester123')
    driver.find_element(css: 'button[type="submit"]').click

    wait = Selenium::WebDriver::Wait.new(timeout: 60)
    wait.until { driver.find_element(id:  'my-account-popover').displayed? }

    expect(driver.find_element(id:  'my-account-popover'))
    puts ">>> PASS: Successful login"


      end
    end
