require_relative "../lib/transform_and_load.rb"

Appointment.first_or_create({
  :defendant_full_name => "Fake Person",
  :room => "3B",
  :date => "20-JAN-15",
  :time => "03:00:00 PM"
})

Citation.first_or_create({
  :guid => "123456789",
  :violation_id => "123456789",
  :location => "123 FAKE STREET",
  :payable => 1
})

Violation.first_or_create({
  :guid => "123456789",
  :description => "A FAKE VIOLATION"
})
