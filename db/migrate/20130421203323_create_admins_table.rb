class CreateAdminsTable < ActiveRecord::Migration
  def up
    create_table "admins" do |t|
      t.string   "username"
      t.string   "hashed_password"
      t.string   "salt"
    end
  end

  def down
    drop_table "admins"
  end
end
