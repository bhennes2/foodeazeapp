class AppointmentsController < ApplicationController
  
  helper_method :sort_column, :sort_direction
  
  def index
    @title = "Today's queue"
    @appointment = Appointment.new
    #@appointments = current_restaurant.appointments.today_queue.order(params[:sort])
    @appointments = Appointment.search(params[:search]).order(sort_column + " " + sort_direction)
    @appointments_sorted = Appointment.order(:party)
    @customers = Customer.all
    @avg_wait_time = avg_wait_time(@appointments)
    
    @table_types = current_restaurant.layout.table_types
    @party_sizes_eating = Appointment.party_eating
    @people_eating = organize_by_party_size(Appointment.eating, @party_sizes_eating)
    
    respond_to do |format|
      format.html
      format.js
      format.json { render :json => @appointments }
    end
  end
  
  def create
    @appointment = Appointment.new(params[:appointment])

    twilio_setup
    
    # If provide telephone # & not already in db, create new customer in database
    if !params[:appointment][:phone].empty?
      if !check_phone_in_db(params[:appointment][:phone])
        customer = Customer.create(:name => params[:appointment][:name], :phone => params[:appointment][:phone])
        @appointment.update_attributes(:customer_id => customer.id)
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
	  	  format.html { redirect_to(appointments_path) }
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
    
    redirect_to :action => 'index'
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
    redirect_to :action => 'index'
  end
  
  def seat
    @appointment = Appointment.find_by_id(params[:id])
    if @appointment.open_table?
      @appointment.update_attributes(:seated => true, :seated_at => Time.now)
    end
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