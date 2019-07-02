RSpec.describe Idoklad::Entities::IssuedInvoice do

  include_context "stub auth"

  describe ".entity_name" do
    it { expect(described_class.entity_name).to eq "IssuedInvoices" }
  end

  it "initialize object" do
    instance = described_class.new({ "id" => 1 })
    expect(instance.id).to eq 1
  end

  describe ".find" do
    it "200" do
      stub_request(:get, "https://app.idoklad.cz/developer/api/v2/IssuedInvoices/1").
        to_return(status: 200, body: { id: 1, DocumentNumber: "20190601" }.to_json)

      expect(described_class.find(1)).to be_a described_class
    end
    it "404" do
      stub_request(:get, "https://app.idoklad.cz/developer/api/v2/IssuedInvoices/1").
        to_return(status: 404, body: "")

      expect(described_class.find(1)).to be_nil
    end
  end

  describe ".default" do
    it do
      stub_request(:get, "https://app.idoklad.cz/developer/api/v2/IssuedInvoices/Default").
        to_return(status: 200, body: { DocumentNumber: "sample string 15" }.to_json)

      expect(described_class.default).to be_a described_class
    end
  end

  describe ".where" do
    it "filter" do
      stub = stub_request(:get, "https://app.idoklad.cz/developer/api/v2/IssuedInvoices?filter=DocumentNumber~eq~123").
        to_return(status: 200, body: "{}")
      described_class.where(filter: "DocumentNumber~eq~123")
      expect(stub).to have_been_made
    end
  end

  describe ".find_by" do
    it "get invoice by number" do
      stub = stub_request(:get, "https://app.idoklad.cz/developer/api/v2/IssuedInvoices?filter=DocumentNumber~eq~123").
        to_return(status: 200, body: { Data: [{ Id: 1, DocumentNumber: 123 }], TotalItems: 1 }.to_json, headers: {})

      expect(described_class.find_by(DocumentNumber: "123")).to be_a described_class

      expect(stub).to have_been_made
    end
  end

  describe "#total" do
    subject { described_class.new({ id: 1, total_with_vat: 300 }) }
    it { expect(subject.total).to eq 300 }
  end

  describe "#number" do
    subject { described_class.new({ id: 1, document_number: "20190601" }) }
    it { expect(subject.number).to eq "20190601" }
  end

  describe "#currency" do
    subject { described_class.new({ id: 1, currency_id: "1" }) }

    it "should return currency object" do
      stub = stub_request(:get, "https://app.idoklad.cz/developer/api/v2/Currencies/1").
        to_return(status: 200, body: { Code: "CZK", Name: "Czech Koruna" }.to_json)
      expect(subject.currency).to be_a Idoklad::Entities::Currency
      expect(stub).to have_been_made

    end

  end

end
