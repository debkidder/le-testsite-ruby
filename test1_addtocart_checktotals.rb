####
# file: test1_addtocart_checktotals.rb
# run from CLI: rspec test1_addtocart_checktotals.rb

require "selenium-webdriver"
require "rspec"

describe "Adding item to cart" do
  it "results in correct totals at Checkout" do

    driver = Selenium::WebDriver.for :chrome

    # Starts on Product Page, add block set to cart (qty 1)
    driver.get 'https://lovevery-test.com/products/the-block-set'

    # wait for button to show
    wait = Selenium::WebDriver::Wait.new(timeout: 5)
    wait.until { driver.find_element(css: 'button[type="submit"]').displayed? }

    # On Product Page
    # Increment qtys while on product page
    driver.find_element(xpath: "//button[@class='input-quantity-btn add']").click
    driver.manage.timeouts.implicit_wait = 5
    driver.find_element(css: 'button[type="submit"]').click

    # Wait for cart to load
    wait = Selenium::WebDriver::Wait.new(timeout: 5)
    wait.until { driver.find_element(xpath: "//button[@class='input-quantity-btn add cart-add-button']").displayed? }

    # Increment qty in cart
    driver.find_element(xpath: "//button[@class='input-quantity-btn add cart-add-button']").click

    # Load Play Gym Page
    driver.get 'https://lovevery-test.com/products/the-play-gym'

    # Wait for Play Gym product page
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    #wait.until { driver.find_element(css: 'button[name="add"]').displayed? }
    wait.until { driver.find_element(xpath:  "//span[@data-add-to-cart-text]").displayed? }

    # On Play Gym product page, add to cart
    driver.find_element(xpath:  "//span[@data-add-to-cart-text]").click

    # In Cart
    wait = Selenium::WebDriver::Wait.new(timeout: 5)
    wait.until { driver.find_element(xpath: "//button[@class='input-quantity-btn add cart-add-button']").displayed? }

    # Wait for Checkout button on Cart to load
    wait = Selenium::WebDriver::Wait.new(timeout: 20)
    wait.until { driver.find_element(css: 'input[name="checkout"]').displayed? }

    # Click Checkout button (in some flows, I have to click it twice by uncommenting all 4 lines...weird)
    driver.find_element(css: 'input[name="checkout"]').click
    #wait = Selenium::WebDriver::Wait.new(timeout: 5)
    #wait.until { driver.find_element(css: 'input[name="checkout"]').displayed? }
    #driver.find_element(css: 'input[name="checkout"]').click


    # Wait for Login form to load
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { driver.find_element(id: 'email').displayed? }

    # Submit login
    driver.find_element(id: 'email').send_keys('TestOctB2020@mailinator.com')
    driver.find_element(css: 'input[id="password"]').send_keys('Tester123')
    driver.find_element(css: 'button[type="submit"]').click

    # Wait for Checkout page and default shipping address to load by waiting for Google Pay button to finish loading
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    #wait.until { driver.find_element(id: 'continue_button').displayed? }
    wait.until { driver.find_element(class: 'dynamic-checkout__buttons').displayed? }

    # (Optional) After Checkout page loads, click checkbox to receive marketing info
    #driver.find_element(id: 'checkout_buyer_accepts_marketing').click

    # (Optional) To try to improve consistency
    driver.manage.timeouts.implicit_wait = 10

    # Asserts correct subtotal
expect(driver.find_element(xpath:  "//span[@data-checkout-subtotal-price-target='41000']"))
puts ">>> PASS: Subtotal Test (actual subtotal matches expected subtotal)"

    # Asserts correct subtotal
expect(driver.find_element(xpath:  "//span[@data-checkout-payment-due-target='41000']"))
puts ">>> PASS: Total Test (actual total matches expected total)"


  end
end
