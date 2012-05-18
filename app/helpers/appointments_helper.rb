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
  
  def wait_time_left(created_at, wait)
    diff = Time.now.utc - created_at
    if (wait*60 - diff) <= 0
      return 0
    else
      diff_minute = ((wait*60-diff)/60).to_i
      diff_second = ((wait*60-diff)%60).to_i
      return "#{diff_minute}:#{diff_second}"
    end
  end
  
  def dinner_time_left(seated_at, wait)
    diff = Time.now.utc - seated_at
    if (wait*60 - diff) <= 0
      return "Overdue.  They should be done now.  Geez!"
    else
      diff_minute = ((wait*60-diff)/60).to_i
      diff_second = ((wait*60-diff)%60).to_i
      return "#{diff_minute}:#{diff_second}"
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
  
  def determine_table_size(tables, party_size)
    tables.each do |table|
      if table.size >= party_size
        return { :size => table.size, :turnover => table.turnover, :quantity => table.quantity }
      elsif table == tables.last #&& table_size_fit == 0
        return { :size => table.size, :turnover => table.turnover, :quantity => table.quantity }
      end
    end
  end
  
  def organize_by_party_size(appointments, party_sizes)
    data = []
    ctr = 0
    prev_party_size = 0
    tables = current_restaurant.table_types.order('size ASC')
    
    party_sizes.each do |party_size|
      if prev_party_size != determine_table_size(tables, party_size.party)[:size]
        data[ctr] = { :party => determine_table_size(tables, party_size.party)[:size], :appointments => [] }
      
        appointments.each do |appt|
          if data[ctr][:party] == appt.table_size_fit_and_turnover[:size]
            data[ctr][:appointments] << appt
          end
        end
        prev_party_size = data[ctr][:party]
        ctr += 1
      end
    end
    data
  end
  
  def dining_time_left(seated_at, turnover)
    diff = Time.now.utc - seated_at
    diff = (diff/60).to_i
    diff = (turnover - diff).ceil
    return diff
  end
  
  def estimated_wait_time(party_size)
    
    tables = current_restaurant.table_types
    
    # issue w/ determining party size
    #size = determine_table_size(tables, party_size)[:size]
    
    result = current_restaurant.table_types.where(:size => party_size).first

    turnover = result.turnover

    total_available = result.quantity

    appts = current_restaurant.appointments.today_queue.where(:seated => true, :done => nil)
    people_eating = Array.new
    
    appts.each do |appt|
      if appt.table_size_fit_and_turnover[:size] == party_size
        people_eating << appt
      end
    end
    
    puts "eating: #{people_eating.count}, seats: #{total_available}"

    if people_eating.count < total_available
      # If no one is waiting
      return "Open"
    elsif people_eating.count == total_available
      # People are now waiting
      
      
      people_eating_time_remaining = Array.new
      people_eating.each do |people|
        people_eating_time_remaining << dining_time_left(people.seated_at, turnover)
      end
      
      people_waiting = current_restaurant.appointments.today_queue.party_waiting_sorted(party_size)
  
      if people_eating.length > people_waiting.length
        # If waiting & # wait line is less than # of people_eating 
        wait_time = 0
        ctr = 0
        (people_waiting.length + 1).times do 
          wait_time += people_eating_time_remaining[ctr]
          ctr += 1
        end
        if wait_time < 0
          return "Check" 
        end
        return wait_time
      elsif people_eating.length <= people_waiting.length
         # If waiting & # wait line is greater than # of people_eating 
         diff = people_waiting.length - people_eating.length + 1
         wait_time = people_eating_time_remaining.inject(:+)
         wait_time += diff * turnover
              if wait_time < 0
                return "Check"
              end
              return wait_time
            end
    end
  end
   
end

