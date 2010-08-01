require "caching"
require "request_limitation"

ActiveResource::Base.class_eval do
  
  def self.inherited(base)
    base.extend RequestLimitation
    base.extend Caching
  end

end
