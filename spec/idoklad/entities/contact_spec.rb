RSpec.describe Idoklad::Entities::Contact do

  include_context "stub auth"

  describe ".entity_name" do
    it { expect(described_class.entity_name).to eq "Contacts" }
  end

  it "get contact" do
    stub_request(:get, "https://app.idoklad.cz/developer/api/v2/Contacts?pagesize=1")
      .to_return(status: 200, body: File.read(File.join(__dir__, "../../fixtures/files/Contacts.json")), headers: {})
    subject = described_class.first
    expect(subject.dic).to eq "sample string 18"
    expect(subject.ico).to eq "sample string 11"
    expect(subject.name).to eq "sample string 4"
    expect(subject.updated_at).to be_a Time
  end

end
