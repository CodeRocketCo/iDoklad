RSpec.describe Idoklad::ParamsParser do
  describe "#filter" do
    it "parse param" do
      subject = described_class.new(filter: { DocumentNumber: "1234" })
      expect(subject.filter).to eq "DocumentNumber~eq~1234"
    end

    it "parse multiple params" do
      subject = described_class.new(filter: { DocumentNumber: "1234", DateOfIssue: "2019-06-30" })
      expect(subject.filter).to eq "DocumentNumber~eq~1234|DateOfIssue~eq~2019-06-30"
    end

    it "parse parsed" do
      subject = described_class.new(filter: "DocumentNumber~eq~1234")
      expect(subject.filter).to eq "DocumentNumber~eq~1234"
    end

  end

  describe "#to_s" do
    it "only filter" do
      subject = described_class.new(filter: { DocumentNumber: "1234" })
      expect(subject.to_s).to eq "filter=DocumentNumber~eq~1234"
    end

    it "filter and sort" do
      subject = described_class.new(sort: "DateOfIssue", filter: { DocumentNumber: "1234" })
      expect(subject.to_s).to eq "filter=DocumentNumber~eq~1234&sort=DateOfIssue~asc"
    end

    it "filter and sort descending" do
      subject = described_class.new(sort: "-DateOfIssue", filter: { DocumentNumber: "1234" })
      expect(subject.to_s).to eq "filter=DocumentNumber~eq~1234&sort=DateOfIssue~desc"
    end
  end
end
