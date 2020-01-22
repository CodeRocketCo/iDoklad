RSpec.describe Idoklad::Entities::Contact do

  include_context "stub auth"

  let(:contact) do
    stub_request(:get, "#{Idoklad::API_URL}/Contacts?pagesize=1")
      .to_return(status: 200, body: File.read(File.join(__dir__, "../../fixtures/files/Contacts.json")), headers: {})
    described_class.first
  end

  describe ".entity_name" do
    it { expect(described_class.entity_name).to eq "Contacts" }
  end

  describe "#ic" do
    subject { contact.ic }
    it { is_expected.to eq "sample string 11"}
  end

  it "get contact" do
    expect(contact.dic).to eq "sample string 21"
    expect(contact.ico).to eq "sample string 11"
    expect(contact.name).to eq "sample string 3"
    expect(contact.updated_at).to be_a Time
  end

end
