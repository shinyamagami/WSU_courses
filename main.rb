require './lib/wsu_in_person'


in_person = WSUInPerson::WSUInPerson.new
#campuses = in_person.get_campus
in_person.get_campus
in_person.scrape_subject_urls
