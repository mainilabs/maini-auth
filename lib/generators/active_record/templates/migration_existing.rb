class AddMainiAuthToDevices < ActiveRecord::Migration
  def self.up
    change_table(:devices) do |t|
<%= migration_data -%>
      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps
    end

    add_index :devices, :authentication_token
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
