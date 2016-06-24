class AddReportToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :report, :string, array: true, default: []
  end
end
