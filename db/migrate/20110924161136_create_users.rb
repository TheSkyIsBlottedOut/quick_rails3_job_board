class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :passcrypt
      t.datetime :validated_at

      t.timestamps
    end
  end
end
