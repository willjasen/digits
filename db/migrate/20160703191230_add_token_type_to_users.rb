class AddTokenTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token_type, :string
  end
end
