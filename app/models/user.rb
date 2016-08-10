class User < ApplicationRecord
    validates :name, presence: true
    validates :email, uniqueness: true
    validates :address, presence: true
    has_secure_password

    geocoded_by :address
    after_validation :geocode


end
