class Employee
  attr_reader :salary

  def initialize(salary)
    @salary = salary
  end

  def bonus(multiplier)
    @bonus = @salary * multiplier
  end

end
