describe ApiKey do
  it 'should generate an access token' do
    a = create(:api_key)
    expect(a.access_token).not_to be_empty
  end
end
