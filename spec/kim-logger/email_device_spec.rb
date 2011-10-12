describe Kim::EmailDevice do
  it "should send an e-mail when in use" do
    Net::SMTP.should_receive :start

    log = Logger.new "test@test.com"
    log.debug "Test"
  end
end

