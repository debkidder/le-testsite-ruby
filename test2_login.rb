###
# file: test2_login.rb
# run from CLI: rspec test2_login.rb

# positive and negative test to make use of variables/methods

require "selenium-webdriver"
require "rspec"

# defines variables
$email_address = 'TestOctB2020@mailinator.com'
$password = 'Tester123'
$bad_email = 'incorrectemail@mailinator.com'
$bad_password = 'incorrectpw1'

# User submits form with good email and good password
def submit_login(driver)
  #wait for login page load
  wait = Selenium::WebDriver::Wait.new(timeout: 10)
  wait.until { driver.find_element(id: 'email').displayed? }

  driver.find_element(id: 'email').send_keys($email_address)
  driver.find_element(css: 'input[name="password"]').send_keys($password)
  driver.find_element(css: 'button[type="submit"]').click
end

# User submits form with bad password
def try_login_badpassword(driver)
  #wait for login page load
  wait = Selenium::WebDriver::Wait.new(timeout: 10)
  wait.until { driver.find_element(id: 'email').displayed? }

  driver.find_element(id: 'email').send_keys($email_address)
  driver.find_element(css: 'input[name="password"]').send_keys($bad_password)
  driver.find_element(css: 'button[type="submit"]').click
end

# method to wait for login and successful login indicator
def wait_login_indicator(driver)
  #wait for form to submit and resulting page load
  wait = Selenium::WebDriver::Wait.new(timeout: 60)
  wait.until { driver.find_element(id:  'my-account-popover').displayed? }
end

# method to wait for bad password indicator
def wait_badpassword_indicator(driver)
  #wait for form to submit and resulting page load
  wait = Selenium::WebDriver::Wait.new(timeout: 20)
  wait.until { driver.find_element(class: 'css-17mbvwi').displayed? }
end

# Rspec Login functionality
describe "Login" do

  # Rspec for successful login
  it "correctly authenticates user and continues to next page" do

    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to 'https://lovevery-test.com/account/login'
    submit_login(driver)
    wait_login_indicator(driver)
    expect(driver.find_element(id:  'my-account-popover'))
    puts ">>> PASS: Successful login if good email and password"
  end

  # Rspec for bad password
  it "correctly pulls up bad password message if bad password" do

    # Test for bad password
    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to 'https://lovevery-test.com/account/login'
    try_login_badpassword(driver)
    wait_badpassword_indicator(driver)
    expect(driver.find_element(class: 'css-17mbvwi'))
    puts ">>> PASS: Correct error message if bad password"

  end
end
