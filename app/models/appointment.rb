class Appointment < ActiveRecord::Base
  
  attr_accessible :name, :party, :wait, :phone, :restaurant_id, :seated, :customer_id, :seated_at
  
  belongs_to :restaurant
  belongs_to :customer

  start_of_day = Time.new(Time.now.year, Time.now.month, Time.now.day)
  scope :today_queue, where("created_at >= :today_start AND created_at <= :now", 
                            { :today_start => start_of_day, :now => Time.now })
                            
  scope :archive_queue, where("created_at <= ?", start_of_day)
  
  scope :unique_parties, order(:party).select(:party).uniq
  
  scope :eating, where(:seated => true, :done => nil).order(:party)
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
    party_size = self.party
    table_types = Restaurant.find_by_id(self.restaurant_id).layout.table_types
    
    table_types.each do |table_type|
      if table_type.size == party_size
        @total_tables = table_type.quantity
      end
    end
    number_eating = Appointment.number_eating_for_party(party_size).count
    @total_tables ||= 0
    if @total_tables == number_eating
      false
    else
      true
    end
    
  end
                     
end
