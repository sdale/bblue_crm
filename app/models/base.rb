class Base < ActiveResource::Base
  extend RequestLimitation
  extend Caching
  def self.inherited(base)
    class << base
      attr_accessor :per_request, :cache_type
    end
    BatchBook::boot
    base.site = BatchBook.account ? "https://#{BatchBook.account}.batchbook.com/service" : ''
    base.user = BatchBook.token
    base.per_request = BatchBook.per_request
    if base.caching?
      options = BatchBook.caching 
      lazy = options['lazy'].split(',')
      lazy.include?(base.name) ?  base.cache_type = 'lazy' : base.cache_type = 'eager'
    end
    super
  end
  
  def self.all(*args)
    self.find(:all, *args)
  end
  
  def self.caching_conditions(*args)
    options = args.extract_options!
    if self.caching?
      options[:caching] = self.cache_type unless options[:caching]
      args << options
    else
      nil
    end
  end
  
  def self.request_limitation_conditions(*args)
    options = args.extract_options!
    unless self.per_request.nil? || self.name == 'Todo'
      options[:request_limit] = self.per_request
      args << options
    else
      nil
    end  
  end
  
  def self.caching?
    !BatchBook.caching.nil? && BatchBook.caching != 'disabled'
  end
  
  def attributes=(data)
    data.each {|key, value|self.send(key+'=', value)} 
  end
  
  def self.paginate(page, per_page=10)
    self.all(:params => {:limit => per_page, :offset => (page * per_page) - per_page }, :disable_request_limitation => true, :disable_caching => true)
  end
  
  def self.find_all_by_param(name, params, cached = true)
    array = []
    if cached && caching?
      params.each{|param|array += self.all(:caching => 'eager').find_all{|obj|obj.send(name) == param}}
    else
      params.each{|param|array += self.all(:params => {name => param}, :disable_request_limitation => true, :disable_caching => true )}
    end
    array
  end
  
end