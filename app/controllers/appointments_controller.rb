class AppointmentsController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  before_filter :signed_in
  
  def index
    @title = "Today's queue"
    
    @appointment = Appointment.new
    #@appointments = current_restaurant.appointments.today_queue.order(params[:sort])
    @appointments = current_restaurant.appointments.today_queue.not_seated.order(sort_column + " " + sort_direction).search(params[:search])
    @appointments_sorted = current_restaurant.appointments.order('party ASC').today_queue.not_seated
    @all_appointments = current_restaurant.appointments.today_queue
    
    @customers = Customer.all
    @avg_wait_time #= avg_wait_time(@appointments)
    
    @table_types = current_restaurant.table_types.order(:size)
    @party_sizes_eating = current_restaurant.appointments.today_queue.party_eating
    @people_eating = organize_by_party_size(current_restaurant.appointments.today_queue.eating, @party_sizes_eating)
     
    @appointments_seated = current_restaurant.appointments.where(:seated => true, :done => nil)
    @table_type = current_restaurant.table_types.where(:size => 6).first
    @open_tables = Array.new
    @appointments_seated.each do |appt|
      @table_type.position.each do |table|
        flag = false
        if table[:id] == appt.table_id
          flag = true
        end
        if !flag
          @open_tables.push(table[:id])
        end
      end
    end
    
    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @appointments }
    end
  end
  
  def create
    @appointment = Appointment.new(params[:appointment])

    twilio_setup
    
    if @appointment.valid?
      # If provide telephone # & not already in db, create new customer in database
      if !params[:appointment][:phone].empty?
        if !check_phone_in_db(params[:appointment][:phone])
          customer = Customer.create(:name => params[:appointment][:name], :phone => params[:appointment][:phone])
          @appointment.update_attributes(:customer_id => customer.id)
        end
      end
    end
    
    # send an sms
    # @client.account.sms.messages.create(
    #         :from => '+14155992671',
    #         :to => "+1#{params[:phone]}",
    #          :body => "Wait is #{params[:wait]} minutes! http://172.28.113.131/customer/1"
    #         )

    respond_to do |format|
      if @appointment.save
	  	  format.html { redirect_to(appointments_path, :notice => "You just booked #{@appointment.name}, party of #{@appointment.party}") }
  	  else
  	    format.html { redirect_to(appointments_path, :notice => "You must enter a name for the appointment") }
      end
    end
  end
  
  def show
    @title = "Archive queue"
    @appointments = current_restaurant.appointments.archive_queue
  end
  
  def destroy
    @appointment = Appointment.find_by_id(params[:id])
    @appointment.destroy
    
    redirect_to appointments_url, :notice => "You just removed #{@appointment.name}, party of #{@appointment.party}"
  end
  
  def sendtext
    
    twilio_setup
    
    # send an sms
    # @client.account.sms.messages.create(
    #           :from => '+14155992671',
    #           :to => "+1#{params[:phone]}",
    #            :body => 'Your table is ready! http://172.28.113.131/customer/1'
    #          )
    #     
    redirect_to appointments_url, :notice => "Text sent to #{params[:phone]}"
  end
  
  def seat
    @appointment = Appointment.find_by_id(params[:id])
    if @appointment.open_table?
      #table_id?????
      @appointments_seated = current_restaurant.appointments.where(:seated => true, :done => nil)
      @table_type = current_restaurant.table_types.where(:size => @appointment.size)
      open_tables = Array.new
      @appointments_seated.each do |appt|
        @table_type.position.each do |table|
          flag = false
          if table.id == appt.table_id
            flag = true
          end
          if !flag
            open_tables.push(table.id)
          end
        end
      end
          
      @appointment.update_attributes(:seated => true, :seated_at => Time.now)
      flash[:notice] = "You just seated #{@appointment.name}, party of #{@appointment.party}"
      redirect_to :action => 'index'
    else
      redirect_to appointments_url, :notice => 'Sorry no table is open right now!'
    end

  end
  
  def book_and_seat
    h = { :name => "Anonymous", :party => params[:party], :wait => 0, :restaurant_id => current_restaurant.id }
      #,:seated => true, :seated_at => Time.now, :phone => params[:phone] }
    
    #table_id??????
    
    appt = Appointment.new(h)   
     
    if appt.open_table?
      appt.save
      appt.update_attributes(:seated => true, :seated_at => Time.now)
    end
    
    
    # if check_phone_in_db(params[:phone])
    #       appt.customer_id = Customer.where(:phone => params[:phone]).first.id
    #     else
    #       #Create new customer
    #       customer = Customer.create(:name => params[:name], :phone => params[:phone])
    #       appt.customer_id = customer.id
    #     end
    
    #send a text for special deals w/ no wait
    
  end
  
  def done
    appt = Appointment.find_by_id(params[:id])
    appt.done = true
    appt.save
    flash[:notice] = "#{appt.name}, party of #{appt.party} just finished their meal!"
    
    redirect_to :action => 'index'
  end

  private
  
    def sort_column
      Appointment.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
  
end