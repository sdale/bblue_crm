class User < ActiveRecord::Base
  include AuthenticatedUser
  validates_presence_of :email, :login, :name
  validates_uniqueness_of :login, :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
end