class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  
  validates :password, :confirmation => true  
  
  has_one :account
  has_many :user_accounts
  has_many :orders, :through => :account
  belongs_to :contact
  
  accepts_nested_attributes_for :account
  
  def has_account
    self.account.nil? ? false : true
  end
  
  def self.lookup(term)
    includes(:account).where("lower(first_name) like (?) or lower(last_name) like (?) or lower(users.email) like (?) or lower(accounts.name) like (?)", "%#{term.downcase}%", "%#{term.downcase}%", "%#{term.downcase}%", "%#{term.downcase}%").references(:account)
  end

  def get_role
    if self.has_role?(:admin)
      role = 'admin'
    elsif self.has_role?(:user)
      role = 'user'
    elsif self.has_role?(:sales)
      role = 'sales'
    elsif self.has_role?(:support)
      role = 'support'
    else
      role = nil
    end
  end
  
end
