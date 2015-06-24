class MainiAuthCreateDevices < ActiveRecord::Migration
  def change
    create_table(:devices) do |t|
<%= migration_data -%>

      t.timestamps
    end

    add_index :devices, :authentication_token
  end
end
