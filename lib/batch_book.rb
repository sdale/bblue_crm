require 'rubygems'
require 'active_resource'

dirname = File.join(File.dirname( __FILE__ ), 'batch_book')
Dir.entries( dirname ).each do |f|
  if f =~ /\.rb$/
    require( File.join(dirname, f) )
  end
end

# Ruby lib for working with the BatchBook's API's XML interface. Set the account
# name and authentication token, using the BatchBook API Key found in your 
# account settings, and you're ready to roll.
#
# http://demo.batchbook.com
# BatchBook.account = 'demo'
# BatchBook.token = 'XYZ'
#
# Edited by Pedro Mateus Tavares | pedromateustavares@gmail.com | http://pedromtavares.wordpress.com

module BatchBook
  VERSION = '1.0.2'
  
  class Error < StandardError; end
  class << self
    attr_accessor :host_format, :site_format, :domain_format, :protocol, :path, :ra_feed_url
    attr_reader :account, :token
 
    # Sets the account name, and updates all the resources with the new domain.
    def account=(name)
      resources.each do |r|
        r.site = r.site_format % (host_format % [protocol, domain_format % name, path])
      end
      @account = name
    end
 
    # Sets the BatchBook API Key for all resources.
    def token=(value)
      resources.each do |r|
        r.user = value
      end
      @token = value
    end

    def per_request=(value)
      resources.each do |r|
        r.per_request = value
      end
    end
 
    def resources
      @resources ||= []
    end
    
    def boot(path = File.join(Rails.root, 'config', 'crm_data.yml'))
      data = YAML::load_file path
      settings = data[Rails.env]
      self.account = settings['account']
      self.token = settings['token']
      self.per_request = settings['per_request']
      self.ra_feed_url = settings['ra_feed_url']
    end
    
  end
  
  self.host_format = '%s://%s/%s/'
  self.domain_format = '%s.batchbook.com'
  self.path = 'service'
  self.protocol = 'https'
 
  class Base < ActiveResource::Base
    extend CachingSupport
    def self.inherited(base)
      BatchBook.resources << base
      class << base
        attr_accessor :site_format, :per_request
      end
      base.site_format = '%s'      
      super
    end
    
    def self.clean_name
      self.name.to_s.gsub("BatchBook::","")
    end
    
    def attributes=(data)
      data.each do |key, value|
        self.send(key+'=', value)
      end
    end

    def self.find(*args)
      return super(*args) if self.clean_name == 'Todo' #quickfix until BB implements offset and limit params on todos API
      if args.first == :all
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
      else
        super(*args)
      end
    end
    
    def self.paginate(page, per_page=10)
      self.find(:all, :params => {:limit => per_page, :offset => (page * per_page) - per_page }, :skip => true) 
    end
    
    def self.find_all_by_param(name, params, cached = true)
      array = []
      if cached
        params.each{|param|array += self.cached('eager').find_all{|obj|obj.send(name) == param}}
      else
        params.each{|param|array += self.find(:all, :params => {name => param}, :skip => true)}
      end
      array
    end
    
  end
  
  class Person < Base
    include TagSupport, LocationSupport, SuperTagSupport

    def type
      'person'
    end

    def name
      unless self.first_name.blank? && self.last_name.blank?
        "#{self.first_name} #{self.last_name}"
      else
        ''
      end
    end 
    
    #add_location only supported on Person, check bottom of the file for a list of params.
    def add_location(params = {})
      params.update(:label => 'home') unless params[:label].present?
      self.post(:locations, :location => params)
    end

    protected
    
    def validate
      errors.add("First Name", "can't be blank.") if self.first_name.blank?
      errors.add("Last Name", "can't be blank.") if self.last_name.blank?
    end
  end

  class Company < Base  
    include TagSupport, LocationSupport, SuperTagSupport
    
    def type
      'company'
    end    
  end

  class Deal < Base
    include TagSupport#, SuperTagSupport
    
    def name
      self.title
    end
    
    def amount
      super.gsub(',','')
    end
    
    #Specific method for my company
    def expected
      case self.status
        when 'lost'
          0
        when '25%'
          self.amount.to_f * 0.25
        when '50%'
          self.amount.to_f * 0.50
        when '75%'
          self.amount.to_f * 0.75
        when '90%'
          self.amount.to_f * 0.90
        when '100%'
          self.amount
      end
    end
    
  end
  
  class Todo < Base
    include TagSupport
  end

  class Communication < Base
    include TagSupport
  end

  class Tag < Base
  end

  class Location < Base
  end

  class SuperTag < Base
  end

end


# Add a Location to a Person
# POST https://test.batchbook.com/service/people/#{id}/locations.xml
# Field Description
# location[label]   Location Name ('work', 'home', etc.) - REQUIRED
# location[email]   Email Address
# location[website]   Website URL
# location[phone]   Phone Number
# location[cell]  Cell Phone Number
# location[fax]   Fax Number
# location[street_1]  Street Address
# location[street_2]  Street Address 2
# location[city]  City
# location[state]   State
# location[postal_code]   Postal Code
# location[country]   Country
