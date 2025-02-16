class User < ApplicationRecord
    has_secure_password
    has_many :tasks, dependent: :destroy
    validates :name, :email, :phone, :status, presence: true
    validates :email, uniqueness: true
    validates :status, inclusion: {in: %w[active inactive]}

end
