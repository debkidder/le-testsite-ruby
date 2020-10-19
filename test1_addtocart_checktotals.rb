####
# file: test1_addtocart_checktotals.rb
# run from CLI: rspec test1_addtocart_checktotals.rb
# Verifies totals on Payment Screen Page



require "selenium-webdriver"
require "rspec"

$email_address = 'TestOctB2020@mailinator.com'
$password = 'Tester123'
$address = '123 Dot St.'
$address2 = 'Apt 1'
$city = 'Boise'
#state = 'ID' Handled differently
$zip = '83705'
$country = 'United States'
$phone = '2081112222'
$ccnumber = '4111111111111111'
$cardholder = 'Proud Mama'
$expiry = '12/2023'
$verification_code = '123'


describe "Adding item to cart" do
 it "results in correct totals at Checkout" do

    driver = Selenium::WebDriver.for :chrome

    # Starts on Product Page, add block set to cart (qty 1)
    driver.get 'https://lovevery-test.com/products/the-block-set'

    # tinker with this waits
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
    wait = Selenium::WebDriver::Wait.new(timeout: 25)
    #wait.until { driver.find_element(css: 'button[name="add"]').displayed? }
    wait.until { driver.find_element(xpath:  "//span[@data-add-to-cart-text]").displayed? }

    # On Play Gym product page, add to cart
    #driver.find_element(css: 'button[name="add"]').click
    driver.find_element(xpath:  "//span[@data-add-to-cart-text]").click

    # In Cart
    wait = Selenium::WebDriver::Wait.new(timeout: 15)
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


    # Wait for Shipping Options form to show
    wait = Selenium::WebDriver::Wait.new(timeout: 20)
    #wait.until { driver.find_element(xpath: "//label[@for='checkout_shipping_address_address1']").displayed? }
    wait.until { driver.find_element(xpath: "//input[@id='checkout_shipping_address_phone']").displayed? }

    #=============================
    # Because saved address seems to be cleared out daily

    # Enter Address 1
    driver.find_element(xpath: "//input[@id='checkout_shipping_address_address1']").send_keys($address)

    # Enter City
    driver.find_element(xpath: "//input[@id='checkout_shipping_address_city']").send_keys($city)

    # Select state (aka province)
    driver.find_element(xpath: "//option[@value='ID']").click

    # Enter zip
    driver.find_element(xpath: "//input[@id='checkout_shipping_address_zip']").send_keys($zip)

    # Enter phone
    driver.find_element(xpath: "//input[@id='checkout_shipping_address_phone']").send_keys($phone)

    driver.manage.timeouts.implicit_wait = 5

    # Click Continue to go to Shipping Method
    driver.find_element(id: 'continue_button').click


    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    #wait.until { driver.find_element(xpath: "//label[@for='checkout_shipping_address_address1']").displayed? }
    wait.until { driver.find_element(xpath: "//div[@class='section section--shipping-method']").displayed? }

    # Leave default shipping (in this test "Free Shipping")

    # Click Continue to go to Payment screen
    driver.find_element(id: 'continue_button').click

    # Wait for Payment screen to load
    wait = Selenium::WebDriver::Wait.new(timeout: 35)
    #wait.until { driver.find_element(xpath: "//label[@for='checkout_shipping_address_address1']").displayed? }
    wait.until { driver.find_element(xpath: "//div[@class='section section--payment-method']").displayed? }


    # Passes if Payment Page subtotal matches hardcoded (for now) $410.00
    expect(driver.find_element(xpath:  "//span[@data-checkout-subtotal-price-target='41000']"))
    puts ">>> PASS: Payment Screen Subtotal (actual subtotal matches expected subtotal)"

    # Passes if Payment Page tax matches hardcoded (for now) $24.60
    expect(driver.find_element(xpath:  "//span[@data-checkout-total-taxes-target='2460']"))
    puts ">>> PASS: Payment Screen Total (actual tax matches expected tax)"

    # Passes if Payment Page total matches hardcoded (for now) $434.60
    expect(driver.find_element(xpath:  "//span[@data-checkout-payment-due-target='43460']"))
    puts ">>> PASS: Payment Screen Total (actual total matches expected total)"

    #TROUBLESHOOTING CREDIT CARD FORM
    # #driver.find_element(xpath: "//input[@id='number']").send_keys($ccnumber)
    # driver.find_element(xpath: "//input[@name='name']").send_keys($cardholder)
    # driver.find_element(xpath: "//input[@id='expiry']").send_keys($expiry)
    # driver.find_element(xpath: "//input[@name='verification_value']").send_keys($verification_code)
    #
    # # Click Continue to go to Payment screen
    # driver.find_element(id: 'continue_button').click
    # driver.find_element(xpath: "//button[@name='button']").click

   driver.quit
  end
 end
