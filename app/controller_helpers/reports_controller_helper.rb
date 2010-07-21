
module ReportsControllerHelper

  Spreadsheet.client_encoding = 'UTF-8'

  HEADERS = {
    'Deal' => [:title, :description, :deal_with, :amount, :status, :expected, :assigned_to ]
  }
  EXTRA = {
    'Deal' => [:deals_sum]
  }

  def render_xls( collection, clazz )
    attributes = HEADERS[ clazz.name ]
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => clazz.name
    sheet1.row(0).concat attributes.map{ |key| key.to_s.titleize }
    sheet1.row(0).default_format = Spreadsheet::Format.new  :weight => :bold
    collection.each do |model|
      vals = []
      attributes.each do |header|
        vals << chained_methods(model,header.to_s.split('.')).to_s
      end
      sheet1.insert_row(sheet1.last_row_index+1, vals)
    end
    EXTRA[clazz.name].each {|call| self.send(call, sheet1, collection)}
    name = "tmp/#{Time.now.strftime("%d-%m-%y-%H-%M")}.xls"
    book.write(name)
    send_data IO.read(name) , :type => 'text/xls', :disposition => "filename=#{clazz.name.pluralize}_#{Time.now.strftime("%d-%m-%y-%H-%M")}.xls"
    File.delete(name)
  end

  protected

  def chained_methods( model, array )
    return if model.nil?
    if array.size == 1
      model.send( array.first )
    else
      result = model.send( array.delete_at(0) )
      chained_methods( result, array )
    end
  end
  
  def deals_sum(sheet, deals)
    format = Spreadsheet::Format.new  :weight => :bold
    sheet.insert_row(sheet.last_row_index+1, [])
    sheet.insert_row(sheet.last_row_index+1, ['Total amount',deals.sum{|deal| deal.amount.to_f}])
    sheet.last_row.default_format = format
    sheet.insert_row(sheet.last_row_index+1, ['Total expected',deals.sum{|deal| deal.expected.to_f}])
    sheet.last_row.default_format = format
  end

end