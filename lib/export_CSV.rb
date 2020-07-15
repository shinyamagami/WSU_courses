#require 'csv'

module exportCSV
  class Error < StandardError; end
  
  
  class exportCSV


    def create(name_of_campus)
      csv = CSV.new(campus + ".csv")
      csv = CSV.open(campus + ".csv", "wb")
    end

    
    def name_column(column_names)
      csv << column_names
    end


    def write_row(row_values)
      csv << row_values
    end
  end
end
