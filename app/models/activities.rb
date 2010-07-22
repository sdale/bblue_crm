class Activities < Base
  def self.recent(page=1)
    self.find(:all, :from => :recent, :params => {:page => page})
  end
end