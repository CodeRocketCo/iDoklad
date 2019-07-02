RSpec.describe Idoklad::Entities::ApiLimit do
  include_context "stub auth"
  it "get limit" do
    stub = stub_request(:get, "https://app.idoklad.cz/developer/api/v2/Test/GetActualApiLimit/").
      to_return(status: 200, body: {
        "DateOfRenewal": "2019-07-02T21:20:52.7818108+00:00",
        "Limit": 2500,
        "ActualRequestCount": 2
      }.to_json)
    limit = described_class.last
    expect(limit.actual_request_count).to eq 2
    expect(limit.date_of_renewal).to be_within(1).of Time.new(2019, 7, 2, 21, 20, 52, "+00:00")
  end
end
