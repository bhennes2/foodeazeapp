puts "Creating waiting appointments"
ctr = 0
50.times do |appt|
  appt = Appointment.new
  appt.name = "Customer #{ctr}"
  appt.party = rand(10) 
  appt.wait = rand(90)
  appt.seated = false
  appt.restaurant_id = 5
  appt.save
  ctr += 1
end

puts "Creating seated appointments"
ctr = 51
50.times do |appt|
  appt = Appointment.new
  appt.name = "Customer #{ctr}"
  appt.party = rand(10) 
  appt.wait = rand(90)
  appt.seated = true
  appt.seated_at = Time.now
  appt.restaurant_id = 5
  appt.save
  ctr += 1
end
