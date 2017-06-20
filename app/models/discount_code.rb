class DiscountCode < ActiveRecord::Base
  include ApplicationHelper

  scope :automatic, -> () { where(:automatic => true) }

  has_many :orders, through: :order_discount_codes
  has_many :order_discount_codes
  has_many :rules, class_name: 'DiscountCodeRule'
  has_one :effect, class_name: 'DiscountCodeEffect', dependent: :destroy
  delegate :name, to: :effect, allow_nil: true

  validates :code, presence: true, uniqueness: true

  after_create {self.create_effect}

  def remaining
    times_of_use - order_discount_codes.size if times_of_use
  end

  def appliable?(order)
    rules.map { |r| r.check(order) }.include?(false)
  end

  def self.lookup(word)
    includes(:effect).where("lower(code) like ? or lower(discount_code_effects.name) like ?", "%#{word.downcase}%", "%#{word.downcase}%").references(:effect)
  end
end