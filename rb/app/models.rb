require 'active_record'
require 'pg'

ActiveRecord::Base.establish_connection(
  adapter:  'postgresql',
  host:     'localhost',
  username: 'courtbot',
  password: 'c0urtb0t!',
  database: 'courtbot_atl',
  encoding: 'unicode',
  pool: 5
) #todo: read from common config

class Appointment < ActiveRecord::Base
  #belongs_to :citation, :reverse_of => :appointments
end

class Citation < ActiveRecord::Base
  #belongs_to :violation, :reverse_of => :citations
  #has_many :appointments, :reverse_of => :citation
end

class Violation < ActiveRecord::Base
  #has_many :citations, :reverse_of => :violation
end
