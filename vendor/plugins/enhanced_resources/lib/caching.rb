module Caching
  
  def find(*args)
    options = args.extract_options!
    return super(*args << options) if args.first != :all || options[:disable_caching]
    type = options[:caching] || 'eager'
    self.recache unless Rails.cache.exist?(self.name)
    case type
      when 'lazy'
      when 'eager'
        last_id = Rails.cache.read('last_id')
        last_time = Rails.cache.read('last_time') || Time.now
        last_object = super(:last, :params => {:updated_since => last_time})
        self.recache if last_id.nil? || (last_object && last_id != last_object.id)
    end
    YAML::load(Rails.cache.read(self.name))
  end
  
  def recache
    ['last_id', 'last_time', self.name].each{|str| Rails.cache.delete(str)}
    now = Time.now
    last = self.find(:last, :params => {:updated_since => now})
    Rails.cache.write('last_id', last.nil? ? 0 : last.id)
    Rails.cache.write('last_time', now)
    Rails.cache.write(self.name, self.find(:all, :disable_caching => true).to_yaml)
  end
  
end