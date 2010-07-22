module BatchBook
  class << self
    attr_accessor :account, :token, :per_request, :ra_feed_url, :caching
  end
  
  def self.boot(path = File.join(Rails.root, 'config', 'crm_data.yml'))
    data = YAML::load_file path
    settings = data[Rails.env] 
    self.account = settings['account']
    self.token = settings['token']
    self.per_request = settings['per_request']
    self.ra_feed_url = settings['ra_feed_url'] 
    self.caching = settings['caching']
  end
end