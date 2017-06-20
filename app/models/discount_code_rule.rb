class DiscountCodeRule < ActiveRecord::Base
  include ApplicationHelper
  attr_accessor :requirable_term
  
  belongs_to :code, class_name: 'DiscountCode', foreign_key: :discount_code_id
  belongs_to :requirable, polymorphic: true
  belongs_to :user_appliable, polymorphic: true
  validate :amount_or_quantity
  validates :discount_code_id, presence: true

  REQUIRABLE_TYPES = ['Item', 'Category']

  def check(order)
    items = order.order_line_items
    if requirable
      items = requirable_type == 'Item' ? items.by_item(requirable_id) : items.by_category(requirable_id)
    end
    user_condition = true
    if user_appliable
      user_condition = user_appliable_type == 'Group' ? user_appliable.users.include?(order.user) : user_appliable == order.user
    end
    amount_sum = items.sum("(COALESCE(quantity,0) - COALESCE(quantity_canceled,0)) * price").to_f
    quantity_sum = items.sum("(COALESCE(quantity,0) - COALESCE(quantity_canceled,0))").to_f
    amount_sum >= amount.to_f && quantity_sum >= quantity.to_f && user_condition
  end

  def amount_or_quantity
    !(amount && quantity)
  end

  def error_message
    if user_appliable
      "Order should belong to #{user_appliable_type == 'Group' ? user_appliable.name : user_appliable.display_name}"
    else
      "Order should contain at least #{amount ? '$' + amount.to_s + ' worth of ' : quantity.to_s + ' ' }#{'\'' + requirable.name + '\' ' if requirable}items"
    end
  end
end