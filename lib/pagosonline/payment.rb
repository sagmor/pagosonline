module Pagosonline
  class Payment < Hashie::Dash
    include Shared

    GATEWAY = "https://gatewaylap.pagosonline.net/ppp-web-gateway/"
    TEST_GATEWAY= "https://stg.gatewaylap.pagosonline.net/ppp-web-gateway/"
    SIGNATURE_JOIN = "~"

    attr_accessor :client

    # Configurables
    property :reference, :required => true
    property :description, :required => true
    property :amount, :required => true
    property :taxed, :required => true, :default => true
    property :currency, :required => true, :default => "COP"
    property :response_url
    property :confirmation_url
    property :extra
    property :buyer_name
    property :buyer_email
    property :language, :default => "es"
    property :expiration_date

    def signature
      Digest::MD5.hexdigest([
        self.client.key,
        self.client.merchant_id,
        self.reference,
        self.amount_for_signature,
        self.currency
      ].join(SIGNATURE_JOIN))
    end

    def form(options = {})
      id = params[:id] || options[:id] || "pagosonline"

      form = <<-EOF
        <form
          action="#{self.gateway_url}"
          method="POST"
          id="#{id}"
          class="#{params[:class]}">
      EOF

      self.params.each do |key, value|
        form << "<input type=\"hidden\" name=\"#{key}\" value=\"#{value}\" />" if value
      end

      form << yield if block_given?

      form << "</form>"

      form
    end

    protected
      def gateway_url
        self.client.test? ? TEST_GATEWAY : GATEWAY
      end

      def params
        params = {
          "merchantId"        => self.client.merchant_id,
          "accountId"         => self.client.account_id,
          "referenceCode"     => self.reference,
          "signature"             => self.signature,
          "amount"             => ( "%.2f" % self.amount ),
          "currency"            => self.currency,
          "description"       => self.description,
          "lng"               => self.language,
          "responseUrl"     => self.response_url,
          "confirmationUrl"  => self.confirmation_url,

          "payerFullName"   => self.buyer_name,
          "buyerEmail"    => self.buyer_email
        }

        unless self.taxed
          params["tax"] = params["taxReturnBase"] = 0
        end

        if self.client.test?
          params["test"] = 1
        end

        if self.expiration_date
          params["expirationDate"] = self.expiration_date.to_s
        end

        if self.extra
          params["extra1"] = self.extra[0,249]
          params["extra2"] = self.extra[250,499]
        end

        params
      end

  end
end
