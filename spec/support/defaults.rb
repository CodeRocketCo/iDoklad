RSpec.shared_context "stub auth" do
  before(:each) { allow(Idoklad::Auth).to receive(:get_token).and_return "secret-token" }

  def success_response(data = {})
    { Data: data, IsSuccess: true, Message: "", StatusCode: 200, ErrorCode: 0 }.to_json
  end
  def error_response(code, message = "")
    { Data: nil, IsSuccess: false, Message: message, StatusCode: code, ErrorCode: 0 }.to_json
  end

end

def file_fixture(file_name)
  File.read(File.join(__dir__, "../fixtures/files/#{file_name}"))
end
