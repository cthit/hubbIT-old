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

  it "to be updated by another device" do
    user = create(:user_with_devices)
    device1, device2 = user.devices

    put "/sessions", params: {macs: [device1.address]}, headers: @headers
    expect(UserSession.active.with_user(user).size).to eq 1
    Timecop.freeze(8.minutes.from_now) do
      put "/sessions", params: {macs: [device2.address]}, headers: @headers
      Timecop.freeze(8.minutes.from_now) do
        expect(UserSession.with_user(user).size).to eq 1
        expect(UserSession.active.with_user(user).size).to eq 1
      end
    end
  end

  it "to expire after some time" do
    device = create(:device)
    user = device.user

    put "/sessions", params: {macs: [device.address]}, headers: @headers
    expect(UserSession.active.with_user(user).size).to eq 1
    Timecop.freeze(15.minutes.from_now) do
      expect(UserSession.with_user(user).size).to eq 1
      expect(UserSession.active.with_user(user)).to be_empty
    end
  end

  it "to be created if the last user session expires" do
    device = create(:device)
    user = device.user

    put "/sessions", params: {macs: [device.address]}, headers: @headers
    expect(UserSession.active.with_user(user).size).to eq 1
    Timecop.freeze(15.minutes.from_now) do
      put "/sessions", params: {macs: [device.address]}, headers: @headers
      expect(UserSession.with_user(user).size).to eq 2
      expect(UserSession.active.with_user(user).size).to eq 1
    end
  end
end
