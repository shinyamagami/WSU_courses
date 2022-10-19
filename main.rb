require './lib/wsu_courses'


courses = WSUInPerson::WSUInPerson.new
#campuses = courses.get_campus
courses.get_campus
#courses.get_time
courses.scrape_subject_urls
