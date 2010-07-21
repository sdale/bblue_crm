Factory.define( :user ) do |t|
  t.name { Factory.next(:name) }
  t.login { Factory.next(:login)}
  t.email { Factory.next(:email) }
  t.password { |f| "123456" }
  t.password_confirmation { |f| "123456" }
end