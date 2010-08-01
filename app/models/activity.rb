class Activity < Base
  def self.recent(page=1)
    self.all(:from => :recent, :params => {:page => page}, :disable_request_limitation => true, :disable_caching => true)
  end
end