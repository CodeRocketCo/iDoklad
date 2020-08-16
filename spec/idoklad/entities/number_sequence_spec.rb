RSpec.describe Idoklad::Entities::NumericSequences do

  include_context "stub auth"

  subject(:entity) { described_class.new("DocumentType" => 4) }

  describe ".find" do
    it "200" do
      stub_request(:get, "#{Idoklad::API_URL}/NumericSequences/1")
        .to_return(status: 200, body: success_response(id: 1))

      subject = described_class.find(1)
      expect(subject).to be_a described_class
    end
  end

  describe "#document_type" do
    subject { entity.document_type }
    it { is_expected.to eq :bank_statement }
  end
  describe "#document_type=" do
    subject { entity.document_type }
    it "assign number" do
      entity.document_type = 7
      is_expected.to eq :sales_order
    end
    it "assign string number" do
      entity.document_type = "3"
      is_expected.to eq :credit_note
    end
    it "assign underscore" do
      entity.document_type = "proforma_invoice"
      is_expected.to eq :proforma_invoice
    end
    it "assign CamelCase" do
      entity.document_type = "CashVoucher"
      is_expected.to eq :cash_voucher
    end
  end
end
