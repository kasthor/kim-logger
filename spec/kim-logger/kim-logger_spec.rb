describe Kim::Logger do 
  let(:logdev) {
    logdev = mock("Log").tap{ |logdev|
      logdev.stub!(:write)
      logdev.stub!(:close)
    }
  }
  it "should be able to replicate normal behavior" do
    logdev.should_receive(:write).with(/Test/)
    log = Logger.new logdev
    log.debug "Test"
  end

  it "should be included in standard logger" do
    log = Logger.new logdev
    log.should respond_to(:add_device)
  end

  it "should send log messages to several devices" do
    logdev2 = mock("Log2").tap { |logdev| 
      logdev.should_receive(:write).with(/Test/)
      logdev.stub! :close
    }
    logdev.should_receive(:write).with(/Test/)
    log = Logger.new logdev
    log.add_device Logger::DEBUG, logdev2

    log.debug "Test"
  end

  it "should recognize when we need an e-mail device" do
    Kim::EmailDevice.should_receive(:new)
    log = Logger.new "test@test.com"
  end
end
