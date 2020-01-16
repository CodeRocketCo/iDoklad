RSpec.describe Idoklad::Entities::IssuedInvoice do

  include_context "stub auth"

  describe ".entity_name" do
    it { expect(described_class.entity_name).to eq "IssuedInvoices" }
  end

  it "initialize object" do
    instance = described_class.new("id" => 1)
    expect(instance.id).to eq 1
  end

  describe ".find" do
    it "200" do
      stub_request(:get, "#{Idoklad::API_URL}/IssuedInvoices/1")
        .to_return(status: 200, body: success_response({ id: 1, DocumentNumber: "20190601" }))

      expect(described_class.find(1)).to be_a described_class
    end
    it "404" do
      stub_request(:get, "#{Idoklad::API_URL}/IssuedInvoices/1")
        .to_return(status: 404, body: error_response(404))

      expect { described_class.find(1) }.to raise_exception Idoklad::ApiError
    end
  end

  describe ".first" do
    it do
      stub_request(:get, "#{Idoklad::API_URL}/IssuedInvoices?pagesize=1")
        .to_return(status: 200, body: success_response(Items: [id: 1, DocumentNumber: "20190601"], TotalItems: 1, TotalPages: 1))
      expect(described_class.first).to be_a described_class
    end
  end

  describe ".default" do
    it do
      stub_request(:get, "#{Idoklad::API_URL}/IssuedInvoices/Default")
        .to_return(status: 200, body: success_response(DocumentNumber: "sample string 15"))

      expect(described_class.default).to be_a described_class
    end
  end

  describe ".all" do
    it "to_h" do
      stub_request(:get, "#{Idoklad::API_URL}/IssuedInvoices")
        .to_return(status: 200, body: file_fixture("IssuedInvoices.json"))
      described_class.all
    end
  end

  describe ".where" do
    it "filter" do
      stub = stub_request(:get, "#{Idoklad::API_URL}/IssuedInvoices?filter=DocumentNumber~eq~123")
               .to_return(status: 200, body: success_response)
      described_class.where(filter: "DocumentNumber~eq~123")
      expect(stub).to have_been_made
    end
  end

  describe ".find_by" do
    it "get invoice by number" do
      stub = stub_request(:get, "#{Idoklad::API_URL}/IssuedInvoices?filter=DocumentNumber~eq~123")
               .to_return(status: 200, body: success_response(Items: [{ Id: 1, DocumentNumber: 123 }], TotalItems: 1))

      expect(described_class.find_by(DocumentNumber: "123")).to be_a described_class

      expect(stub).to have_been_made
    end
  end

  describe "#total" do
    context "without prices" do
      subject { described_class.new(id: 1, total_with_vat: 300) }
      it { expect(subject.total).to be_nil }
    end
    context "without prices" do
      subject { described_class.new(JSON.parse(file_fixture("IssuedInvoice.json"))["Data"]) }
      it { expect(subject.total).to eq 9 }
    end
  end

  describe "#number" do
    subject { described_class.new(id: 1, document_number: "20190601") }
    it { expect(subject.number).to eq "20190601" }
  end

  describe "#currency" do
    subject { described_class.new(id: 1, currency_id: "1") }

    it "should return currency object" do
      stub = stub_request(:get, "#{Idoklad::API_URL}/Currencies/1")
               .to_return(status: 200, body: success_response(Code: "CZK", Name: "Czech Koruna", Symbol: "Kč"))
      expect(subject.currency).to be_a Idoklad::Entities::Currency
      expect(stub).to have_been_made
      expect(subject.currency.to_s).to eq "Kč"
    end

  end

  describe "#currency=" do
    subject { described_class.new id: 1 }
    it "assign Currency object" do
      subject.currency = Idoklad::Entities::Currency.new id: 1, code: "eur"
      expect(subject.currency).to be_a Idoklad::Entities::Currency
      expect(subject.currency.code).to eq "eur"
    end

    context "assign currency symbol" do

      it "valid symbol" do
        stub = stub_request(:get, "#{Idoklad::API_URL}/Currencies?filter=code~eq~eur")
                 .to_return(status: 200, body: success_response(JSON.parse(file_fixture("Currencies.json"))["Data"]))

        subject.currency = "eur"
        expect(stub).to have_been_made
        expect(subject.currency).to be_a Idoklad::Entities::Currency
        expect(subject.currency).to eq subject.currency
      end

      it "nil" do
        subject.currency = nil
        expect(subject.currency).to be_nil
      end

    end
  end

  context "partner" do
    subject(:entity) { described_class.new id: 1 }
    let(:contact) { Idoklad::Entities::Contact.new Id: 1, CompanyName: "Cipisek" }
    describe "#partner" do
      subject { entity.partner }
      it "assign nil" do
        entity.partner = nil
        is_expected.to be_nil
      end
      it "reassign" do
        entity.partner = contact
        is_expected.to be_a Idoklad::Entities::Contact
      end
      it 'should alias' do
        entity.contact = contact
        expect(entity.contact).to be_a Idoklad::Entities::Contact
      end
    end

    describe "#partner_id" do
      it 'should remove instance variable @partner' do
        subject = described_class.new Id: 1
        subject.contact = contact
        expect(subject.partner_id = nil).to be_nil
        expect(subject.instance_variables).not_to include :@partner
        expect { subject.partner_id = nil }.not_to raise_error
      end
    end
  end
  describe "#status" do
    subject { described_class.new(id: 1, payment_status: 1) }
    it { expect(subject.status).to eq :paid }
    it { expect(subject.paid?).to eq true }
  end

  describe "#destroy" do
    it "destroy existing" do
      stub_request(:delete, "#{Idoklad::API_URL}/IssuedInvoices/1")
        .to_return(status: 200, body: success_response)
      instance = described_class.new("id" => 1)
      expect(instance.destroy).to eq true
    end

    it "404" do
      stub_request(:delete, "#{Idoklad::API_URL}/IssuedInvoices/1")
        .to_return(status: 404, body: error_response(404, "Not found"))
      instance = described_class.new("id" => 1)
      expect { instance.destroy }.to raise_exception Idoklad::ApiError
    end
  end

  describe ".save" do
    it "create new one" do
      stub_request(:post, "#{Idoklad::API_URL}/IssuedInvoices")
        .to_return(status: 200, body: success_response(id: 1, number: "x1"))
      instance = described_class.new(number: "x1")
      expect(instance.save).to eq true
      expect(instance.id).to eq 1
    end

    it "validation error on create" do
      stub_request(:post, "#{Idoklad::API_URL}/IssuedInvoices")
        .with(body: { PurchaserId: "12" })
        .to_return(status: 400, body: error_response(400, "Required property 'Number' not found in JSON"))
      instance = described_class.new(purchaser_id: "12")
      expect(instance.save).to eq false
      expect(instance.errors).to include kind_of(String)
    end
  end

  describe "#attributes=" do
    it "assign hash" do
      instance = described_class.new(purchaser_id: "12")
      instance.attributes = { account_number: "1234/566", description: "test" }
      expect(instance.account_number).to eq "1234/566"
      expect(instance).to have_attributes purchaser_id: "12", description: "test"
    end
  end
end
