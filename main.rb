require './lib/WSU_In_Person'





inperson = WSUInPerson::WSUInPerson.new
campuses = inperson.get_campus
inperson.scrape_subject_urls(campuses)
