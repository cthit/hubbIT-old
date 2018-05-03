describe "Session update" do
  it "to create a user session if a user is seen by the sniffer", type: :request do
    device = create(:device)
    token = create(:api_key)

    headers = {
      "Authorization" => "Token #{token.access_token}"
    }

    put "/sessions", params: {macs: [device.address]}, headers: headers
    expect(Session.active.with_mac(device.address)).not_to be_empty
  end
end
