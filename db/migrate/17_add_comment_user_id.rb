class TempComment < ActiveRecord::Base
  belongs_to :text_filter
  set_table_name 'comments'
end

class AddCommentUserId < ActiveRecord::Migration
  def self.up
    users = Hash.new
    
    TempComment.transaction do
      add_column :comments, :user_id, :integer
      
      TempComment.find(:all).each do |c|
        userid = nil
        if users[c.email]
          c.user_id = users[c.email]
          c.save
        elsif user = User.find_by_email(c.email)
          c.user_id = user.id
          users[c.email] = user.id
          c.save
        end
      end
    end
  end

  def self.down
    remove_column :comments, :user_id
  end
end