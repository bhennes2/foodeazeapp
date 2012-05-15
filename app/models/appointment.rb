class Appointment < ActiveRecord::Base
  
  include AppointmentsHelper
  
  attr_accessible :name, :party, :wait, :phone, :restaurant_id, :seated, :customer_id, :seated_at, :location
  
  belongs_to :restaurant
  belongs_to :customer
  
  validates :name, :presence => true

  start_of_day = Time.new(Time.now.year, Time.now.month, Time.now.day)
  scope :today_queue, where("created_at >= :today_start", { :today_start => start_of_day } )
  scope :not_seated, where(:seated => false)
                            
  scope :archive_queue, where("created_at <= ?", start_of_day)
  
  scope :unique_parties, order(:party).select(:party).uniq
  
  scope :eating, where(:seated => true, :done => nil).order(:party)
  scope :party_eating_sorted, lambda { |size| where(:seated => true, :done => nil, :party => size).order("seated_at ASC") }
  scope :party_waiting_sorted, lambda { |size| where(:seated => false, :done => nil, :party => size).order("created_at ASC") }
  
  scope :party_eating, where(:seated => true, :done => nil).select(:party).uniq
  scope :number_eating_for_party, lambda { |size| where(:seated => true, :done => nil, :party => size).order(:party) }

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def open_table?
    party_size = self.table_size_fit_and_turnover[:size]
    table_types = Restaurant.find_by_id(self.restaurant_id).table_types
    
    table_types.each do |table_type|
      if table_type.size == party_size
        @total_tables = table_type.quantity
      end
    end
    
    number_eating = Appointment.number_eating_for_party(party_size).count
    @total_tables ||= 0
    if @total_tables <= number_eating
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
