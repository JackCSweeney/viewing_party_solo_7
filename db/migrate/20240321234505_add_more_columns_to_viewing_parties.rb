class AddMoreColumnsToViewingParties < ActiveRecord::Migration[7.1]
  def change
    add_column :viewing_parties, :guest_email_1, :string
    add_column :viewing_parties, :guest_email_2, :string
    add_column :viewing_parties, :guest_email_3, :string
  end
end
