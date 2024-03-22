require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  before(:each) do
    @user_1 = User.create!(name: 'Sam', email: 'sam@email.com')
    @user_2 = User.create!(name: 'Tommy', email: 'tommy@email.com')
    @party = ViewingParty.create!(date: "2023-12-01", start_time: "07:25", duration: 175, movie_duration: 132, movie_id: 1, guest_email_1: @user_2.email)
  end

  describe '#validations' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:duration) }
    it { should validate_presence_of(:movie_id) }
    it { should validate_presence_of(:movie_duration) }
    it { should validate_numericality_of(:movie_duration) }
  end

  describe 'make_user_parties(host_id)' do
    it 'can trigger the creation of user parties' do
      @party.make_user_parties(@user_1.id)

      expect(@user_1.user_parties.first.viewing_party_id).to eq(@party.id)
      expect(@user_2.user_parties.first.viewing_party_id).to eq(@party.id)
    end
  end
  
  describe 'relationships' do
    it { should have_many :user_parties }
    it { should have_many(:users).through(:user_parties) }
  end

  describe "instance methods" do
    it "returns user that is hosting the party" do
      @party.make_user_parties(@user_1.id)

      expect(@party.find_host).to eq (@user_1)
    end

    describe '#guests?' do
      it 'returns true if any guest emails were included' do
        expect(@party.guests?).to eq(true)

        party_2 = ViewingParty.create!(date: "2023-12-01", start_time: "07:25", duration: 175, movie_duration: 132, movie_id: 1)

        expect(party_2.guests?).to eq(false)
      end
    end
  end
end