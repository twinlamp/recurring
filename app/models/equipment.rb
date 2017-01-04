class Equipment < ActiveRecord::Base
  include ApplicationHelper
  
  before_save :make_record_number
  
  belongs_to :customer, :foreign_key => "account_id"
  belongs_to :machine_model, :foreign_key => "model_id"
  has_one :contact
  has_many :meters
  has_many :alerts, :class_name => "EquipmentAlert"
  
end