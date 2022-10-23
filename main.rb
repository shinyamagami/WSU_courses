require './lib/wsu_courses'


courses = WSUcourses::WSUcourses.new
#campuses = courses.get_campus
courses.get_campus
#courses.get_time
courses.scrape_subject_urls
