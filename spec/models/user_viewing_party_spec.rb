require 'rails_helper'

RSpec.describe UserParty, type: :model do
  describe 'validations and relationships' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :viewing_party }
    
    it { should belong_to :user }
    it { should belong_to :viewing_party }
  end

  describe 'class methods' do
    describe 'self.create_user_parties(viewing_party)' do
      it 'creates new user_parties' do
        @user_1 = User.create!(name: 'Jack', email: 'jack@email.com')
        @user_2 = User.create!(name: 'Tommy', email: 'tommy@email.com')

        viewing_party = ViewingParty.create!(date: "2023-12-01", start_time: "07:25", duration: 175, movie_duration: 132, movie_id: 1, guest_email_1: "jack@email.com")
        user_parties = UserParty.create_user_parties(viewing_party, @user_1.id)

        expect(user_parties).to be_a(Array)
        expect(user_parties.first).to be_a(UserParty)
        expect(user_parties.first.host).to eq(true)
        expect(user_parties[1].host).to eq(false)
      end
    end
  end
end