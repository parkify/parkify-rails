class AddAttachmentImageAttachmentToImages < ActiveRecord::Migration
  def self.up
    change_table :images do |t|

      t.has_attached_file :image_attachment

    end
  end

  def self.down

    drop_attached_file :images, :image_attachment

  end
end
