module Kim
  class EmailDevice
    attr_accessor :email, :settings
    
    #DEFAULTS
    @@settings = { 
        :from => 'logger@localhost',
        :subject => 'Email Log',
        :host => 'localhost',
        :port => 25
      }

    def initialize email, settings = {}
      self.email = email
      self.settings = settings
    end

    def write message
      send_email effective_settings[:from], self.email, message
    end

    def close
      # Do nothing
    end

    def self.settings
      @@settings
    end

    def self.settings= value
      @@settings = value
    end

    def effective_settings
      @@settings.deep_merge self.settings
    end

    private 
    
    def send_email from, to, message
      email = <<-MESSAGE
        From: #{from}
        To: #{to}
        Subject: #{ effective_settings[:subject] }

        #{message}
      MESSAGE

      Net::SMTP.start effective_settings[:host], effective_settings[:port] do |smtp|
        smtp.send_message message, from, to
      end
    end
  end
end
