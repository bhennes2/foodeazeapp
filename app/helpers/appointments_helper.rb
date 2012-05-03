module AppointmentsHelper
  
  def party_sizes(appointments)
    @parties = appointments.unique_parties
    party_sizes = Array.new
    @parties.each do |size|
      party_sizes.push(size.party)
    end
    party_sizes
  end
  
  def twilio_setup
    # put your own credentials here
    account_sid = 'ACbf5205e06b1e525c7423a2684db25ca6'
    auth_token = '77a3354287f2383260c893b06f41e54c'

    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token
    return @client
  end
  
  def wait_time_left(time, wait)
    diff = Time.now.utc - time
    diff = diff/60.to_i
    diff = (wait - diff).ceil
    if diff <= 0
      return 0
    else
      return diff
    end
  end
  
  def check_phone_in_db(phone)
    if !Customer.where(:phone => phone).empty?
      return true
    else
      return false
    end
  end
  
  def avg_wait_time(appointments)
    total_wait = 0
    appointments.each do |appointment|
      total_wait += appointment.wait
    end
    (total_wait/appointments.size).to_i
  end
  
  def party_wait_time(party_size)
    appointments = Appointment.where(:party => party_size)
    total_wait = 0
    if !appointments.empty?
      appointments.each do |appointment|
        total_wait += appointment.wait
      end
      (total_wait/appointments.size).to_i
    else
      total_wait
    end
  end
  
  def organize_by_party_size(appointments, party_sizes)
    data = []
    ctr = 0
    party_sizes.each do |party_size|
      data[ctr] = { :party => party_size.party, :appointments => [] }
      
      appointments.each do |appt|
        if data[ctr][:party] == appt.party
          data[ctr][:appointments] << appt
        end
      end

      ctr += 1
    end
    data
  end
  
  def dining_time_left(time, wait)
    diff = Time.now.utc - time
    diff = diff/60.to_i
    diff = (wait - diff).ceil
    diff
  end
  
end