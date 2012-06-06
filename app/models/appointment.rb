class Appointment < ActiveRecord::Base
  
  include AppointmentsHelper
  
  attr_accessible :name, :party, :wait, :phone, :restaurant_id, :seated, :customer_id, :seated_at, :location
  
  belongs_to :restaurant
  belongs_to :customer
  
  validates :name, :presence => true

  start_of_day = Time.new(Time.now.year, Time.now.month, Time.now.day, 0, 0).utc
  scope :today_queue, where("created_at >= :today_start", { :today_start => start_of_day } )
  scope :not_seated, where(:seated => false)
                            
  scope :archive_queue, where("created_at <= ?", start_of_day)
  
  scope :unique_parties, order(:party).select(:party).uniq
  
  scope :eating, where(:seated => true, :done => nil).order(:party)
  scope :party_eating_sorted, lambda { |size| where(:seated => true, :done => nil, :party => size).order("seated_at ASC") }
  scope :party_waiting_sorted, lambda { |size| where(:seated => false, :done => nil, :party => size).order("created_at ASC") }
  
  scope :party_eating, where(:seated => true, :done => nil).order("seated_at ASC").select(:party).uniq
  scope :number_eating_for_party, lambda { |size| where(:seated => true, :done => nil, :party => size).order(:party) }

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def open_table?
    result = self.table_size_fit_and_turnover
    party_size = result[:size]
    total_tables = result[:quantity]
    
    appointments = Appointment.today_queue.where(:seated => true, :done => nil)
    number_eating = 0
    
    appointments.each do |appt|
      if appt.table_size_fit_and_turnover[:size] == party_size
        number_eating += 1
      end
    end
    
    if total_tables <= number_eating
      false
    else
      true
    end
    
  end

  def table_size_fit_and_turnover
    party_size = self.party
    tables = Restaurant.find_by_id(self.restaurant_id).table_types.order('size ASC')

    return determine_table_size(tables, party_size)

  end
                     
end
