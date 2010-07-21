class Activities < Base
  def self.recent
    self.find(:all, :from => :recent)
  end
end