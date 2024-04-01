require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should allow_value('something@something.something').for(:email) }
    it { should_not allow_value('something somthing@something.something').for(:email) }
    it { should_not allow_value('something.something@').for(:email) }
    it { should_not allow_value('something').for(:email) }
    it { should validate_presence_of(:password_digest) }
    it { should have_secure_password }
  end

  describe 'associations' do
    it { should have_many :user_parties }
    it { should have_many(:viewing_parties).through(:user_parties) }
  end

  it 'can create a new user' do
    user = User.create!(name: "Jack", email: "jack@email.com", password: "password1", password_confirmation: "password1")

    expect(user).to be_a(User)
    expect(user).not_to have_attribute(:password)
    expect(user.password_digest).not_to eq("password1")
  end
end