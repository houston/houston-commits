class DropUnusedTables2 < ActiveRecord::Migration
  def up
    remove_column :deploys, :environment_id if column_exists? :deploys, :environment_id
    drop_table :historical_heads if table_exists? :historical_heads
    remove_column :pull_requests, :labels if column_exists? :pull_requests, :labels
    remove_column :pull_requests, :old_labels if column_exists? :pull_requests, :old_labels
  end

  def down
    add_column :deploys, :environment_id, :integer
    create_table :historical_heads do |t|
      t.integer :project_id, null: false
      t.hstore :branches, null: false, default: {}
      t.timestamps
    end
    add_column :pull_requests, :old_labels, :text, default: "", null: false
    add_column :pull_requests, :labels, :text, array: true, default: [], null: false
  end
end
