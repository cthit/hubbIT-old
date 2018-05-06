describe User do
  it 'should destroy all related data upon deletion' do
    device = create(:device)
    user = device.user
    session = create(:session, user: user, device: device)
    user_session = create(:user_session, user: user)

    other_session = create(:session)
    other_user_session = create(:user_session)
    user.destroy

    expect(Session.all).not_to be_empty
    expect(UserSession.all).not_to be_empty
    expect(Session.with_user(user)).to be_empty
    expect(UserSession.with_user(user)).to be_empty
    expect(MacAddress.where(user: user)).to be_empty
  end
end
