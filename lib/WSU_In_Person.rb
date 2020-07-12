#require "WSU_In_Person/version"
require 'nokogiri'
require 'open-uri'
require 'csv'


module WSUInPerson
  class Error < StandardError; end
  
  class WSUInPerson

    
    def scrape_subject_urls
      
      doc = Nokogiri::HTML(open('http://schedules.wsu.edu/List/Pullman/20203'))
      subjects = doc.css('.prefixList').css('a')
  
  
      subject_urls = []
      prefixes = []

      subjects.each do |subject|
        subject_urls << subject.attribute('href').value
        prefixes << subject.text.strip
      end

      
      scrape_course_pages(subject_urls, prefixes)
    end
  
  
    def scrape_course_pages(subject_urls, prefixes)


      csv = CSV.new("output.csv")
      csv = CSV.open("output.csv", "wb")
      csv << ["Prefix", "Course Title", "Section", "Class Number", "Time"]

      i = 0

      
      subject_urls.each do |subject_url|
        section_urls = []
        sections = []

        begin
          prefix =  prefixes.at(i)
          name = ""
          sec = ""
          classnum = ""
          room_spec = ""

          doc = Nokogiri::HTML(open("http://schedules.wsu.edu#{subject_url}"))
          section_links = doc.css('.class_schedule').css('.section').css('a')


          trs = doc.css('.class_schedule').css('tr')
          trs.each do |tr|

            name_on = 0
            sec_on = 0

            if tr.css('td').text.strip.start_with?(prefix)
              name = tr.css('td').text.strip.split(' ').drop(1).join(' ')

              
            elsif tr.attr('class') == "section"
              sec = tr.css('td').map(&:text)[1].strip
              classnum = tr.css('td').map(&:text)[2].strip
              room_spec = tr.css('td').map(&:text)[4].strip
              

            else
              #skip
            end
            if room_spec != "WEB ARR"
              puts name + " " + sec + " " + classnum + " " + room_spec
              csv << [prefix, name, sec, classnum, room_spec]
            end
          end

          



          section_links.each do |section_link|
            section_urls << section_link.attribute('href').value
            sections << section_link.text.strip
          end



#          scrape_section_pages(section_urls, prefix, csv, sections)
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

    
    def scrape_section_pages(section_urls, prefix, csv, sections)
      i = 0
  
      section_urls.each do |section_url|

        doc = Nokogiri::HTML(open("http://schedules.wsu.edu#{section_url}"))
        roomspec = doc.at('.sectionInfo').at('.roomspec').text.strip
  
  
        # Not sure if WEB ARR is online or in-person yet
        if roomspec != "WEB ARR"
          class_name = doc.at('.sectionInfo').at('b').text.strip
          class_number = doc.at('.sectionInfo')
                           .at("//dt[text()='Class Number']/following-sibling::dd").text

          puts prefix + "\t" + class_name + "\t" + sections.at(i) + "\t" + class_number
          csv << [prefix, class_name, sections.at(i), class_number]
        end
        
        i+=1
      end
  
    end
  end
  
  scrape = WSUInPerson.new
  scrape.scrape_subject_urls
end
