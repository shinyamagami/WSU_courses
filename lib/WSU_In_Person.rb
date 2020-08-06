#require "WSU_In_Person/version"
require 'nokogiri'
require 'open-uri'
require 'csv'
require './lib/export_csv'


module WSUInPerson
  class Error < StandardError; end
  
  class WSUInPerson

    def get_campus
      @campuses = ["Pullman", "Spokane", "Tri-Cities", "Vancouver", "Everett", "DDP"]

      puts "For which campus do you want to get?\n
      1.Pullman\n
      2.Spokane\n
      3.Tri-Cities\n
      4.Vancouver\n
      5.Everett\n
      6.Global\n
      7.All\n"

      temp_campus = gets.chomp

      if temp_campus == "1"
        @campuses = @campuses.values_at(0)
      elsif temp_campus == "2"
        @campuses = @campuses.values_at(1)
      elsif temp_campus == "3"
        @campuses = @campuses.values_at(2)
      elsif temp_campus == "4"
        @campuses = @campuses.values_at(3)
      elsif temp_campus == "5"
        @campuses = @campuses.values_at(4)
      elsif temp_campus == "6"
        @campuses = @campuses.values_at(5)
      else
      end

      puts @campuses
      #return campuses
    end


    def scrape_subject_urls

      @campuses.each do |campus|

        doc = Nokogiri::HTML(open('http://schedules.wsu.edu/List/'+ campus+ '/20202'))

        subjects = doc.css('.prefixList').css('a')
    
        subject_urls = []
        prefixes = []

        subjects.each do |subject|
          subject_urls << subject.attribute('href').value
          prefixes << subject.text.strip
        end
        
        scrape_course_pages(subject_urls, prefixes, campus)
      end
    end
  
  
    def scrape_course_pages(subject_urls, prefixes, campus)

      csv = ExportCSV::ExportCSV.new
      csv.create(campus)
      column_names = ["Prefix", "Course Number", "Course Title", "Section", "Class Number", "Credit", "Days & Times",
        "Bldg & Room", "Instructor"]
      csv.name_column(column_names)


      # for prefix counter
      i = 0
      
      subject_urls.each do |subject_url|
        section_urls = []
        sections = []

        begin
          prefix =  prefixes.at(i)
          name = ""
          course_number = ""
          sec = ""
          classnum = ""
          credit = ""
          sched_days = ""
          sched_loc = ""
          instructor = ""
          name_on = 0
          sec_on = 0

          doc = Nokogiri::HTML(open("http://schedules.wsu.edu#{subject_url}"))
          #section_links = doc.css('.class_schedule').css('.section').css('a')


          trs = doc.css('.class_schedule').css('tr')
          trs.each do |tr|

            # this part need to be updated often
            if tr.css('td').text.strip.start_with?(prefix)  
              temp_name = tr.css('td').text.strip.split(' ').drop(1).join(' ')
              #puts temp_name
              course_number = temp_name.split.first
              name = temp_name.split(' ').drop(1).join(' ')
            end


            if tr.attr('class') == "section" || tr.attr('class') == "section subdued"
              sec = tr.css('td').map(&:text)[1].strip
              classnum = tr.css('td').map(&:text)[2].strip
              credit = tr.css('td').map(&:text)[3].strip
              sched_days = tr.css('td').map(&:text)[4].strip

              # some classes don't have sched_loc parts
              begin
                sched_loc = tr.css('td').map(&:text)[5].strip
              rescue NoMethodError => e
              rescue => e
              end

              # some classes don't have instructor parts
              begin
                instructor = tr.css('td').map(&:text)[7].strip
              rescue NoMethodError => e
              rescue => e
              end
              

              #for when a section part has multiple lines
              if !sec.start_with?("0", "1", "2", "3", "4", "5", "6")
                sched_days = sec
                sched_loc = classnum
                sec = ""
                classnum = ""
                credit = ""
                instructor = ""
              end

              sec_on = 1
            end


            #if sched_loc != "WEB ARR" && sec_on == 1
            if sec_on == 1
              puts course_number + " " + name + " " + sec + " " +
                  classnum + " " + credit + " " + sched_days + " " +
                  sched_loc + " " + instructor
              #csv << [prefix, course_number, name, sec, classnum, credit, sched_days, sched_loc, instructor]
              values = [prefix, course_number, name, sec, classnum, credit, sched_days, sched_loc, instructor]
              csv.write_row(values)

              sec = ""
              classnum = ""
              credit = ""
              sched_days = ""
              sched_loc = ""
              instructor = ""

              sec_on = 0
            end
            sec_on = 0
          end

=begin
          section_links.each do |section_link|
            section_urls << section_link.attribute('href').value
            sections << section_link.text.strip
          end
=end

          i+=1
        rescue OpenURI::HTTPError => e
          if e.message == '404 Not Found'
            #puts subject_url.text + "cannot be opend!!"
          else
            raise e
          end
          i+=1
        end
      end
    end

  
    # takes too long to open so I abandoned to scrape from section pages
    # def scrape_section_pages(section_urls, prefix, csv, sections)
    #   i = 0
  
    #   section_urls.each do |section_url|

    #     doc = Nokogiri::HTML(open("http://schedules.wsu.edu#{section_url}"))
    #     roomspec = doc.at('.sectionInfo').at('.roomspec').text.strip
  
    #     # Not sure if WEB ARR is online or in-person yet
    #     if roomspec != "WEB ARR"
    #       class_name = doc.at('.sectionInfo').at('b').text.strip
    #       class_number = doc.at('.sectionInfo')
    #                        .at("//dt[text()='Class Number']/following-sibling::dd").text

    #       puts prefix + "\t" + class_name + "\t" + sections.at(i) + "\t" + class_number
    #       csv << [prefix, class_name, sections.at(i), class_number]
    #     end
    #     i+=1
    #   end
    # end

  end
  

end
