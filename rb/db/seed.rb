require_relative "../app/models.rb"

violation = Violation.where({
  :guid => "123456789",
  :description => "A FAKE VIOLATION"
}).first_or_create!

citation = Citation.where({
  :guid => "987654321",
  :violation_id => violation.id,
  :location => "123 FAKE STREET",
  :payable => 1
}).first_or_create!

appointment = Appointment.where({
  :citation_id => citation.id,
  :defendant_full_name => "FAKE PERSON",
  :room => "3B",
  :date => "20-JAN-15",
  :time => "03:00:00 PM"
}).first_or_create!

puts "SEEDED"
