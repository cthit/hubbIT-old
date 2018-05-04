describe "User session" do
  before :each do
    @token = create(:api_key)
    @headers = {
      "Authorization" => "Token #{@token.access_token}"
    }
  end

  it "to be created if a user is seen by the sniffer" do
    device = create(:device)

    expect(UserSession.active.size).to eq 0
    put "/sessions", params: {macs: [device.address]}, headers: @headers
    expect(UserSession.all.size).to eq 1
    expect(UserSession.active.size).to eq 1
    expect(UserSession.active.with_user(device.user).size).to eq 1
  end

  it "to be created if a user with multiple devices is seen by the sniffer" do
    user = create(:user_with_devices)
    device1, device2 = user.devices

    expect(UserSession.active.size).to eq 0
    put "/sessions", params: {macs: [device1.address]}, headers: @headers
    expect(UserSession.all.size).to eq 1
    expect(UserSession.active.size).to eq 1
    expect(UserSession.active.with_user(user).size).to eq 1

    put "/sessions", params: {macs: [device2.address]}, headers: @headers
    expect(UserSession.all.size).to eq 1
    expect(UserSession.active.size).to eq 1
    expect(UserSession.active.with_user(user).size).to eq 1
  end
end
