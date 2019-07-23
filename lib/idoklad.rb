require 'json'

module Idoklad

  API_URL = 'https://app.idoklad.cz'

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
    autoload :ApiLimit, "idoklad/entities/api_limit"
    autoload :Contact, "idoklad/entities/contact"
    autoload :Currency, "idoklad/entities/currency"
    autoload :IssuedInvoice, "idoklad/entities/issued_invoice"
  end

  class IdokladError < StandardError

  end

  class EntityNotFound < IdokladError

  end

  autoload :ApiRequest, "idoklad/api_request"
  autoload :Auth, "idoklad/auth"
  autoload :Base, "idoklad/base"
  autoload :ParamsParser, "idoklad/params_parser"
end

require 'idoklad/issued_invoices'
