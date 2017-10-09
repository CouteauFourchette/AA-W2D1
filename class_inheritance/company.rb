require_relative 'employee'
require_relative 'manager'


shawna = Employee.new(12000)

david = Employee.new(10000)

darren = Manager.new(78000, [shawna, david])

ned = Manager.new(1000000, [darren])


puts ned.bonus(5) # => 500_000
puts darren.bonus(4) # => 88_000
puts david.bonus(3) # => 30_000
