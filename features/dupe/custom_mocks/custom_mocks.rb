# Example:

###### Workaround for the bug on person object ######
Get %r{/people\.xml} do
  Dupe.find(:humans)
end

Get %r{/people/(\d+)\.xml} do |id|
 Dupe.find(:human) {|h| h.id == id.to_i}
end

Post %r{/people\.xml} do |data|
  Dupe.create :human, data
end
Put %r{/people/(\d+)\.xml} do |id,put_data|
  raise Dupe::UnprocessableEntity.new(:first_name => " must be present.") unless put_data[:first_name]
  Dupe.find(:human) {|h| h.id == id.to_i}.merge! put_data
end

Delete %r{/people/(\d+)\.xml} do |id|
  Dupe.delete(:human) {|h| h.id == id.to_i}
end

###### Deals ######
Get %r{/deals\.xml\?assigned_to=(.*)} do |name|
  Dupe.find(:deals){|d| d.assigned_to = name}
end

Get %r{/deals\.xml\?status=(.*)} do |status|
  Dupe.find(:deals){|d| d.status = status}
end


###### Locations Support ######

Get %r{/people/(\d+)\/locations\.xml} do |id|
  Dupe.find(:human) {|h| h.id == id.to_i}.locations
end

Get %r{/companies/(\d+)\/locations\.xml} do |id|
  Dupe.find(:company) {|c| c.id == id.to_i}.locations
end

###### Supertag Support ######

#List
Get %r{/people/(\d+)\/super_tags\.xml} do |id|
  Dupe.find(:human) {|h| h.id == id.to_i}.supertags
end

Get %r{/companies/(\d+)\/super_tags\.xml} do |id|
  Dupe.find(:company) {|c| c.id == id.to_i}.supertags
end

#Add
Put %r{/people/(\d+)\/add_tag\.xml\?tag=(.*)} do |id, name|
  tag = Dupe.create(:tag, :name => name)
  Dupe.find(:human) {|h| h.id == id.to_i}.tags = tag
end

Put %r{/people/(\d+)\/super_tags/(.*)\.xml} do |id, tag_name, data|
  tag = Dupe.find(:tag) {|t| t.name == tag_name}
  tag.merge! data
end

#Delete
Delete %r{/people/(\d+)\/remove_tag\.xml?(.*)} do |id, data|
  Dupe.find(:human) {|h| h.id == id.to_i}.delete(data)
end

Delete %r{/companies/(\d+)\/remove_tag\.xml?(.*)} do |id, data|
  Dupe.find(:company) {|h| h.id == id.to_i}.delete(data)
end

