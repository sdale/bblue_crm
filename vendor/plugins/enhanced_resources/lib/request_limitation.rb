module RequestLimitation
  
  def find(*args)
    options = args.extract_options!
    return super(*args << options) if args.first != :all || options[:disable_request_limitation]
    args << options
    total, counter = [], 0
    while true
      options = args.extract_options!
      request_limit = options[:request_limit] || 100
      params = options[:params] || {}
      params = params.merge(:limit => request_limit)
      params = params.merge(:offset => request_limit * counter)
      options = options.merge(:params => params)
      temp = super(*args << options)
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