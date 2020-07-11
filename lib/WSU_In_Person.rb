#require "WSU_In_Person/version"
require 'nokogiri'
require 'open-uri'
require 'csv'
#require 'pry'

module WSUInPerson
  class Error < StandardError; end
  
  class WSUInPerson

    
    def scrape_subject_urls
      
      doc = Nokogiri::HTML(open('http://schedules.wsu.edu/List/Pullman/20203'))
      subjects = doc.css('.prefixList').css('a')
  
      doc = Nokogiri::HTML(open('http://schedules.wsu.edu/List/Pullman/20203'))
      temp_prefixes = doc.css('.prefixList').css('a')
  
      subject_urls = []
      prefixes = []
  
      subjects.each do |subject|
        url = subject.attribute('href').value
        subject_urls << url
      end
  
      temp_prefixes.each do |temp_prefix|
        prefixes << temp_prefix.text.strip
      end
      
 
      scrape_course_pages(subject_urls, prefixes)
    end
  
  
  
    def scrape_course_pages(subject_urls, prefixes)


#        csv << ["row", "of", "CSV", "data"]
 #       csv << ["another", "row"]

      csv = CSV.new("output.csv")
      csv = CSV.open("output.csv", "wb")
      csv << ["Prefix", "Course Title", "Class Number"]
      
      i = 0
  
      subject_urls.each do |subject_url|
        section_urls = []
  
        doc = Nokogiri::HTML(open("http://schedules.wsu.edu#{subject_url}"))
        sections = doc.css('.class_schedule').css('.section').css('a')
  
        
        sections.each do |section|
          url = section.attribute('href').value
          section_urls << url
        end
        prefix =  prefixes.at(i)
        i+=1
        scrape_section_pages(section_urls, prefix, csv)
      end
  
    end
  
    def scrape_section_pages(section_urls, prefix, csv)
      in_persons = []
  
      section_urls.each do |section_url|
        #puts section_url
        doc = Nokogiri::HTML(open("http://schedules.wsu.edu#{section_url}"))
        roomspec = doc.at('.sectionInfo').at('.roomspec').text.strip
  
  
        # Not sure if WEB ARR is online or in-person yet
        if roomspec != "WEB ARR"
          class_name = doc.at('.sectionInfo').at('b').text.strip
          class_number = doc.at('.sectionInfo')
                           .at("//dt[text()='Class Number']/following-sibling::dd").text
                           #.text.string
          puts prefix + "\t" + class_name + "\t" + class_number
          csv << [prefix, class_name, class_number]
        end
          #sections.each do |secion|
           # url = section.attribute('href').value
            #section_urls << url
      #end
      end
  
    end
  end
  
  scrape = WSUInPerson.new
  scrape.scrape_subject_urls
end
