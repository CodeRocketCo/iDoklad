RSpec.shared_context "stub auth" do
  before(:each) { allow(Idoklad::Auth).to receive(:get_token).and_return "secret-token" }
end
