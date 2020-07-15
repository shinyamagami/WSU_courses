#require 'csv'

module ExportCSV
  class Error < StandardError; end
  
  
  class ExportCSV


    def create(name_of_campus)
      @csv = CSV.new(name_of_campus + ".csv")
      @csv = CSV.open(name_of_campus + ".csv", "wb")
    end

    
    def name_column(column_names)
      @csv << column_names
    end


    def write_row(row_values)
      @csv << row_values
    end
  end
end
