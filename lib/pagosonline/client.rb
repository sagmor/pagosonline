module Pagosonline
  class Client
    attr_accessor :merchant_id, :account_id, :login, :key
    def initialize(options = {})
      self.merchant_id  = options[:merchant_id]
      self.account_id   = options[:account_id]
      self.login        = options[:login]
      self.key          = options[:key]
      self.test         = !!options[:test]
    end

    def payment(options)
      Pagosonline::Payment.new(options).tap do |payment|
        payment.client = self
      end
    end

    def response(options)
      Pagosonline::Response.new(options).tap do |response|
        response.client = self
      end
    end

    def test?
      @test
    end

    def test=(test)
      @test = test
    end
  end
end
