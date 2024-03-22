class UserParty < ApplicationRecord
  validates_presence_of :user, :viewing_party
  
  belongs_to :viewing_party
  belongs_to :user

  def self.create_user_parties(viewing_party, host_id)
    guest_emails = [viewing_party[:guest_email_1], viewing_party[:guest_email_2], viewing_party[:guest_email_3]].compact - [""]

    user_parties = []

    user_parties << UserParty.create!({user_id: host_id, viewing_party_id: viewing_party.id, host: true})
    
    if !guest_emails.empty?
      guest_emails.each do |email|
        user = User.find_by(email: email)
        user_parties << UserParty.create!({user_id: user.id, viewing_party_id: viewing_party.id, host: false})
      end
    end
    user_parties
  end
end
