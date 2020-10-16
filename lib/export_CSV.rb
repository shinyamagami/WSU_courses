module ExportCSV
  class Error < StandardError; end
  
  
  class ExportCSV


    def create(name_of_campus, time)
      file_name = "./outputs/" + name_of_campus + "_" + time + ".csv"
      @csv = CSV.new(file_name)
      @csv = CSV.open(file_name, "wb")
    end

    
    def name_column(column_names)
      @csv << column_names
    end


    def write_row(row_values)
      @csv << row_values
    end
  end
end
