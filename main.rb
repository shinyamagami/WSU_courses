require './lib/WSU_In_Person'


puts "From which campus do you want to get?\n
      1.Pullman\n
      2.Spokane\n
      3.Tri-Cities\n
      4.Vancouver\n
      5.Everett\n
      6.Global\n"

temp_campus = gets.chomp


if temp_campus == "1"
  campus = "Pullman"
elsif temp_campus == "2"
  campus = "Spokane"
elsif temp_campus == "3"
  campus = "Tri-Cities"
elsif temp_campus == "4"
  campus = "Vancouver"
elsif temp_campus == "5"
  campus = "Everett"
elsif temp_campus == "6"
  campus = "DDP"
else
end

puts campus

csv = CSV.new(campus + ".csv")
csv = CSV.open(campus + ".csv", "wb")


scrape = WSUInPerson::WSUInPerson.new
scrape.scrape_subject_urls(campus, csv)
