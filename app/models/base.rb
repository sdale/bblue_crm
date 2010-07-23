class Base < ActiveResource::Base
  extend CachingSupport
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
  
  def self.caching?
    !BatchBook.caching.nil? && BatchBook.caching != 'disabled'
  end
  
  def attributes=(data)
    data.each {|key, value|self.send(key+'=', value)} 
  end
  
  def self.find(*args)
    return super(*args) if self.per_request.nil? || args.first != :all || self.name == 'Todo' #quickfix until BB implements offset and limit params on todos API
    total, counter = [], 0
    while true
      options = args.extract_options!
      return super(*args << options) if options[:skip]
      params = options[:params] || {}
      params = params.merge(:limit => self.per_request)
      params = params.merge(:offset => self.per_request * counter)
      options = options.merge(:params => params)
      args << options
      temp = super(*args)
      if temp.blank?
        break
      else
        total << temp
        counter+=1
      end
    end
    total.flatten
  end
  
  def self.paginate(page, per_page=10)
    self.find(:all, :params => {:limit => per_page, :offset => (page * per_page) - per_page }, :skip => true)
  end
  
  def self.find_all_by_param(name, params, cached = true)
    array = []
    if cached && caching?
      params.each{|param|array += self.cached('eager').find_all{|obj|obj.send(name) == param}}
    else
      params.each{|param|array += self.find(:all, :params => {name => param}, :skip => true )}
    end
    array
  end
  
end