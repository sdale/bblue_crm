
module DealsControllerHelper
  
  def final_report(filter)
    deals = []
    unless filter[:users].blank?
      users = User.all(:conditions => {:name => filter[:users]})
      Deal.caching? ? users.map!{|user|user.name} : users.map!{|user|user.email}
      deals += Deal.find_all_by_param(:assigned_to, users)
    end
      deals += Deal.find_all_by_param(:status, filter[:status]) unless filter[:status].blank?
      deals += date_filter(:>=) unless filter[:date_from].blank?
      deals += date_filter(:<=) unless filter[:date_from].blank?
      deals.delete_if{|deal| !filter[:status].include?(deal.status)} if filter[:users] && filter[:status]
      deals.uniq
  end
  
  def date_filter(method)
    begin
      test = Deal.find(:first).supertags
    rescue
      test = nil
    end
    if test.nil?
      flash[:warning] = 'Date filter is unavailable!'
      Deal.all
    else
      Deal.find_all_by_supertag('dealinfo') do |tag|
          tag.first['fields']['close_date'].to_date.send(method, filter[:date_to].to_date)
      end
    end
  end
  
  def selected_users(filter)
    filter.nil? || filter[:users].nil? ? ['everyone'] : filter[:users]
  end
  
end