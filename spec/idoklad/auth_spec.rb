RSpec.describe Idoklad::Auth do
  it ".get_token" do
    stub = stub_request(:post, "https://identity.idoklad.cz/server/connect/token").
      with(
        body: hash_including({ grant_type: "client_credentials", scope: "idoklad_api" })).
      to_return(status: 200, body: { access_token: "super-secret", token_type: "Bearer" }.to_json, headers: { "Content-Type" => "application/json" })
    expect(described_class.get_token).to eq "super-secret"
    expect(stub).to have_been_made
  end
end
