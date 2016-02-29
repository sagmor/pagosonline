module Pagosonline
  module Shared
    def amount_for_signature
      amount = "%.2f" % self.amount

      if amount.chars.last == '0'
        amount[0...-1]
      else
        amount
      end
    end
  end
end
