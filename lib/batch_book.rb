require 'rubygems'
require 'active_resource'

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
    
    def boot(path)
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
        total.flatten!
      else
        super(*args)
      end
    end
    
    def self.paginate(page, per_page=10)
      self.find(:all, :params => {:limit => per_page, :offset => (page * per_page) - per_page }, :skip => true)
    end
    
    def self.find_all_by_param(name, params)
      array = []
      params.each{|param|array += self.find(:all, :params => {name => param}, :skip => true)}
      array
    end
    
  end
  #Resources
  class Person < Base
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

    protected
    #Currently unsupported by the API
    def validate
      errors.add("first_name", "can't be blank.") if self.first_name.blank?
      errors.add("last_name", "can't be blank.") if self.last_name.blank?
    end
  end

  class Company < Base  
    def type
      'company'
    end        
  end

  class Deal < Base
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
  end

  class Communication < Base
  end

  class Tag < Base
  end

  class Location < Base
  end

  class SuperTag < Base
  end

  #Tag support(Person, Company, Deal, Communication and Todo)
  [Person, Company].each do |klass|
    klass.class_eval do
      def tags
        Tag.find(:all, :params => {:contact_id => self.id})
      end  
    end
  end
  [Deal, Communication, Todo].each do |klass|
    klass.class_eval %Q!
      def tags
        Tag.find(:all, :params => {#{klass.name.downcase.to_sym}_id => self.id})
      end
    !
  end
  
  #Locations support(Person and Company)
  [Person, Company].each do |klass|
    klass.class_eval do        
      def locations
        self.get('locations')     
      end
      
      def location label
        raise Error, "Location label not specified.  Usage:  #{klass.clean_name.downcase}.location('label_name')" unless label
        self.get('locations', :label => label)             
      end
    end   
  end
  
  #Supertag support(Person, Company, Deal)
  [Person, Company, Deal].each do |klass|
    klass.class_eval do 
      def self.find_all_by_supertag(supertag, &block)
        array = []
        all = self.find(:all)
        all.each do |one|
          supertags = one.supertags
          next if supertags.blank?
          temp = supertags.find{|e| e['name'] == supertag}
          array << one unless temp.blank? || temp['fields'].blank?
        end
        if block_given?
          array.find_all(&block)
        else
          array
        end
      end
      
      def supertags   
        self.get('super_tags')
      end
    
      def supertag name
        raise Error, "SuperTag name not specified.  Usage:  #{klass.clean_name.downcase}.supertag('tag_name')" unless name
        self.get('super_tags', :name => name)    
      end

      def add_tag tag
        raise Error, "#{tag} is not a BatchBook::Tag" unless tag.kind_of?(BatchBook::Tag)
        tag.put(:add_to, :contact_id => id)
      end
    
      def remove_tag tag
        raise Error, "#{tag} is not a BatchBook::Tag" unless tag.kind_of?(BatchBook::Tag)
        tag.put(:remove_from, :contact_id => id)
      end
   end
 end

end



__END__

require 'batchbook'
BatchBook.account = 'devo'
BatchBook.token = 'xyZ'

search_by_name = BatchBook::Person.find(:all, :params => {:name => 'will'} )
search_by_email = BatchBook::Person.find(:all, :params => {:email => will@batchblue.com})

person = BatchBook::Person.find 1937
person.last_name = 'new last name'
person.save

new_person = BatchBook::Person.new :first_name => 'will', :last_name => 'larson', :title => 'dev'
new_person.save
