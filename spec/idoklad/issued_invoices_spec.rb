RSpec.describe Idoklad::IssuedInvoices do
  describe ".get_list" do
    it do
      expect(Idoklad::ApiRequest).to receive(:get).with('/developer/api/v2/IssuedInvoices').and_return double(body: "[]")
      described_class.get_list
    end
  end
  describe ".get_default" do
    it do
      expect(Idoklad::ApiRequest).to receive(:get).with('/developer/api/v2/IssuedInvoices/Default').and_return double(body: "[]")
      described_class.get_default
    end
  end
  describe ".create" do
    it do
      expect(Idoklad::ApiRequest).to receive(:post).with('/developer/api/v2/IssuedInvoices', {}).and_return double(body: "[]")
      described_class.create({})
    end
  end
end
