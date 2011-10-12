require "kim"
require "logger"
require "net/smtp"
require "./lib/kim-logger/version"
require "./lib/kim-logger/email_device"

Logger.class_exec do
  # Redefine initialization to have the same behavior 
  # but instead of just one logdev create an array of devices with multiple a log level for each
  def initialize logdev, shift_age = 0, shift_size = 1048576, options = {}
    @formater = nil
    @progname = nil
    @default_formatter = Logger::Formatter.new

    @logdevs = [] 

    options[:shift_age] ||= shift_age
    options[:shift_size] ||= shift_size

    add_device Logger::DEBUG, logdev, options
  end

  def add severity, message = nil, progname = nil, &block
    severity ||= Logger::UNKNOWN

    progname ||= @progname

    unless message
      if block_given?
        message = yield
      else
        message = progname
        progname = @progname
      end
    end

    @logdevs.each do | logdev |
      next unless severity >= logdev[:level]

      logdev[:dev].write( format_message( format_severity(severity), Time.now, progname, message ))
    end

    true
  end

  def << msg
    @logdevs.each{|item| item[:dev].write msg }
  end

  def add_device severity, logdev, options = {}
    case logdev
      when /^[A-Za-z0-9+.%_-]+@[A-Za-z0-9+.%_-]+\.[A-Za-z0-9+.%_-]+$/ # is email
        @logdevs << { :dev =>  Kim::EmailDevice.new(logdev, options), :level => severity }
      else
        @logdevs << { :dev => ::Logger::LogDevice.new(logdev, options), :level => severity }
    end

    cleanup_devices
  end

  def close
    @logdevs.each{|item| item[:dev].close }
  end

  # Level is no longer a 1 variable statement, but for backward compatibility I'm assuming it refers to the first device

  def level
    @logdevs[0][:level] if @logdevs[0]
  end

  def level= value
    @logdevs[0][:level] = value if @logdevs[0]
  end

  private 

  def cleanup_devices
    @logdevs.reject!{|dev| dev.nil?}
  end
end
