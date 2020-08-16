require 'json'

module Idoklad

  API_URL = 'https://api.idoklad.cz/v3'

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end

  class Configuration
    attr_accessor :client_id, :client_secret
  end

  module Entities
    autoload :Country, "idoklad/entities/country"
    autoload :Contact, "idoklad/entities/contact"
    autoload :Currency, "idoklad/entities/currency"
    autoload :IssuedInvoice, "idoklad/entities/issued_invoice"
    autoload :NumericSequences, "idoklad/entities/numeric_sequence"
  end

  class IdokladError < StandardError

  end

  autoload :ApiError, "idoklad/api_error"
  autoload :ApiRequest, "idoklad/api_request"
  autoload :Auth, "idoklad/auth"
  autoload :Base, "idoklad/base"
  autoload :ParamsParser, "idoklad/params_parser"
end

require 'idoklad/issued_invoices'
