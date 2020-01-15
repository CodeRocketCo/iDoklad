RSpec.describe Idoklad::ApiRequest do
  include_context "stub auth"

  describe ".get" do
    it "200" do
      stub_request(:get, "#{Idoklad::API_URL}/IssuedInvoices/1").
        to_return(status: 200, body: success_response)

      described_class.get "/IssuedInvoices/1"
    end
    it "404" do
      stub_request(:get, "#{Idoklad::API_URL}/IssuedInvoices/1").
        to_return(status: 404, body: error_response(404, "IssuedInvoice with id 1 was not found."))

      expect { described_class.get "/IssuedInvoices/1" }.to raise_error do |error|
        expect(error).to be_a(Idoklad::ApiError)
        expect(error.message).to eq "IssuedInvoice with id 1 was not found."
        expect(error.code).to eq 404
      end
    end
  end

  describe ".post" do
    it "201" do
      body = { NumericSequenceId: 1 }
      stub_request(:post, "#{Idoklad::API_URL}/IssuedInvoices").
        with(body: body.to_json).
        to_return(status: 200, body: success_response)

      described_class.post "/IssuedInvoices", body
    end
  end

  describe ".delete" do
    it "200" do
      stub_request(:delete, "#{Idoklad::API_URL}/IssuedInvoices/1").
        to_return(status: 200, body: success_response)

      described_class.delete "/IssuedInvoices/1"
    end

    it "404" do
      stub_request(:delete, "#{Idoklad::API_URL}/IssuedInvoices/1").
        to_return(status: 404, body: error_response(404))

      expect { described_class.delete "/IssuedInvoices/1" }.to raise_error Idoklad::ApiError
    end
  end
end
