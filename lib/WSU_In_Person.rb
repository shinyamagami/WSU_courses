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



      csv = CSV.new("output.csv")
      csv = CSV.open("output.csv", "wb")
      csv << ["Prefix", "Course Title", "Section", "Class Number"]
      
      i = 0
  
      subject_urls.each do |subject_url|
        section_urls = []
        sections = []

        begin
        
          doc = Nokogiri::HTML(open("http://schedules.wsu.edu#{subject_url}"))
          section_links = doc.css('.class_schedule').css('.section').css('a')
          temp_sections = doc.css('.class_schedule').css('.section').css('a')
          
          section_links.each do |section_link|
            url = section_link.attribute('href').value
            section_urls << url
          end

          temp_sections.each do |temp_section|
            sections << temp_section.text.strip
          end
          
          prefix =  prefixes.at(i)
          i+=1
          scrape_section_pages(section_urls, prefix, csv, sections)

        rescue OpenURI::HTTPError => e
          if e.message == '404 Not Found'
            puts subject_url.text + "cannot be opend!!"
          else
            raise e
          end
        end
      end
    end
  
    def scrape_section_pages(section_urls, prefix, csv, sections)
      i = 0
  
      section_urls.each do |section_url|
        #puts section_url
        doc = Nokogiri::HTML(open("http://schedules.wsu.edu#{section_url}"))
        roomspec = doc.at('.sectionInfo').at('.roomspec').text.strip
  
  
        # Not sure if WEB ARR is online or in-person yet
        if roomspec != "WEB ARR"
          class_name = doc.at('.sectionInfo').at('b').text.strip
          class_number = doc.at('.sectionInfo')
                           .at("//dt[text()='Class Number']/following-sibling::dd").text

        # puts prefix + "\t" + class_name + "\t" + sections.at(i) + "\t" + class_number
          csv << [prefix, class_name, sections.at(i), class_number]
        end
        
        i+=1
      end
  
    end
  end
  
  scrape = WSUInPerson.new
  scrape.scrape_subject_urls
end
