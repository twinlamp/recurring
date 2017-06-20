class AddUserAppliableTypeUserAppliableIdToDiscountCodeRule < ActiveRecord::Migration
  def change
    add_column :discount_code_rules, :user_appliable_type, :string
    add_column :discount_code_rules, :user_appliable_id, :integer
  end
end
