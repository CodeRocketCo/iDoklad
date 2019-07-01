RSpec.describe Idoklad::ApiRequest do
  before :each do
    allow(Idoklad::Auth).to receive(:get_token).and_return "secret-token"
  end
  describe ".get" do
    it "200" do
      stub_request(:get, "https://app.idoklad.cz/developer/api/v2/IssuedInvoices/1").
        to_return(status: 200, body: "")

      described_class.get "/developer/api/v2/IssuedInvoices/1"
    end
    it "404" do
      stub_request(:get, "https://app.idoklad.cz/developer/api/v2/IssuedInvoices/1").
        to_return(status: 404, body: "")

      described_class.get "/developer/api/v2/IssuedInvoices/1"
    end
  end

  describe ".post" do
    it "201" do
      body = { NumericSequenceId: 1 }
      stub_request(:post, "https://app.idoklad.cz/developer/api/v2/IssuedInvoices").
        with(body: body.to_json).
        to_return(status: 200, body: "")

      described_class.post "/developer/api/v2/IssuedInvoices", body
    end
  end
end
