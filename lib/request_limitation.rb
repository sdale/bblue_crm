module RequestLimitation
  
  def find(*args)
    options = args.extract_options!
    return super(*args) unless args.first == :all && !options[:disable_request_limitation] && self.respond_to?(:request_limitation_conditions) && self.request_limitation_conditions(*args)
    args = request_limitation_conditions(*args << options)
    total, counter = [], 0
    while true
      options = args.extract_options!
      request_limit = options[:request_limit] || 100
      params = options[:params] || {}
      params = params.merge(:limit => request_limit)
      params = params.merge(:offset => request_limit * counter)
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
  
end