module CachingSupport
  
  def find_with_caching(*args)
    options = BatchBook.caching
    lazy = options['lazy'].split(',')
    eager = options['eager'].split(',')
    if lazy.include?(self.name)
      self.cached
    else
      self.cached('eager')
    end
  end
  
  def cached(type = 'lazy')
    self.recache unless Rails.cache.exist?(self.name)
    case type
      when 'lazy'
      when 'eager'
        last_id = Rails.cache.read('last_id')
        last_time = Rails.cache.read('last_time') || Time.now
        last_object = self.find(:last, :params => {:updated_since => last_time}, :raw => true )
        self.recache if last_id.nil? || (last_object && last_id != last_object.id)
    end
    YAML::load(Rails.cache.read(self.name))
  end
  
  def recache
    ['last_id', 'last_time', self.name].each{|str| Rails.cache.delete(str)}
    now = Time.now
    last = self.find(:last, :params => {:updated_since => now}, :raw => true )
    Rails.cache.write('last_id', last.nil? ? 0 : last.id)
    Rails.cache.write('last_time', now)
    Rails.cache.write(self.name, self.find(:all, :raw => true ).to_yaml)
  end
end