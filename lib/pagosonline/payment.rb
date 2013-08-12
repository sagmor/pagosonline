module Pagosonline
  class Payment < Hashie::Dash
    GATEWAY = "https://gatewaylap.pagosonline.net/ppp-web-gateway/"
    TEST_GATEWAY= "https://stg.gatewaylap.pagosonline.net/ppp-web-gateway/"
    SIGNATURE_JOIN = "~"

    attr_accessor :client

    # Configurables
    property :reference, :required => true
    property :description, :required => true
    property :amount, :required => true
    property :currency, :required => true, :default => "COP"
    property :response_url
    property :confirmation_url
    property :extra
    property :buyer_name
    property :buyer_email
    property :language, :default => "es"

    def signature
      Digest::MD5.hexdigest([
        self.client.key,
        self.client.merchant_id,
        self.reference,
        self.amount.to_i,
        self.currency
      ].join(SIGNATURE_JOIN))
    end

    def form(options = {})
      id = params[:id] || "pagosonline"

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
          "usuarioId"         => self.client.merchant_id,
          "cuentaId"          => self.client.account_id,
          "refVenta"          => self.reference,
          "firma"             => self.signature,
          "valor"             => self.amount.to_i,
          "iva"               => nil,
          "baseDevolucionIva" => nil,
          "moneda"            => self.currency,
          "descripcion"       => self.description,
          "lng"               => self.language,
          "url_respuesta"     => self.response_url,
          "url_confirmacion"  => self.confirmation_url,

          "nombreComprador"   => self.buyer_name,
          "emailComprador"    => self.buyer_email
        }

        if self.client.test?
          params["prueba"] = 1
        end

        if self.extra
          params["extra1"] = self.extra[0,249]
          params["extra2"] = self.extra[250,499]
        end

        params
      end

  end
end
