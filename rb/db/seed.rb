require_relative "../app/models.rb"

Appointment.where({
  :defendant_full_name => "FAKE PERSON",
  :room => "3B",
  :date => "20-JAN-15",
  :time => "03:00:00 PM"
}).first_or_create!

Citation.where({
  :guid => "123456789",
  :violation_id => "123456789",
  :location => "123 FAKE STREET",
  :payable => 1
}).first_or_create!

Violation.where({
  :guid => "123456789",
  :description => "A FAKE VIOLATION"
}).first_or_create!
