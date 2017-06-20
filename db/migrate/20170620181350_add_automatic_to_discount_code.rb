class AddAutomaticToDiscountCode < ActiveRecord::Migration
  def change
    add_column :discount_codes, :automatic, :boolean, default: false
  end
end
