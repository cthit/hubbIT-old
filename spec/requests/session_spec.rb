describe "Session" do
  before :each do
    @device = create(:device)
    @token = create(:api_key)
    @headers = {
      "Authorization" => "Token #{@token.access_token}"
    }
  end

  it "to be created if a user is seen by the sniffer" do
    put "/sessions", params: {macs: [@device.address]}, headers: @headers
    expect(Session.with_mac(@device.address).size).to eq 1
    expect(Session.active.with_mac(@device.address).size).to eq 1
  end

  it "to be updated if a recently present user is seen by the sniffer" do
    put "/sessions", params: {macs: [@device.address]}, headers: @headers
    Timecop.freeze(8.minutes.from_now) do
      put "/sessions", params: {macs: [@device.address]}, headers: @headers
      Timecop.freeze(8.minutes.from_now) do
        expect(Session.with_mac(@device.address).size).to eq 1
        expect(Session.active.with_mac(@device.address).size).to eq 1
      end
    end
  end

  it "to expire after some time" do
    put "/sessions", params: {macs: [@device.address]}, headers: @headers
    Timecop.freeze(11.minutes.from_now) do
      expect(Session.with_mac(@device.address).size).to eq 1
      expect(Session.active.with_mac(@device.address)).to be_empty
    end
  end

  it "to be created if the last session expires" do
    put "/sessions", params: {macs: [@device.address]}, headers: @headers
    Timecop.freeze(12.minutes.from_now) do
      put "/sessions", params: {macs: [@device.address]}, headers: @headers
      expect(Session.with_mac(@device.address).size).to eq 2
      expect(Session.active.with_mac(@device.address).size).to eq 1
    end
  end
end
