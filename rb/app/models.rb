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
end

class Citation < ActiveRecord::Base
end

class Violation < ActiveRecord::Base
  self.primary_key = :guid
end
