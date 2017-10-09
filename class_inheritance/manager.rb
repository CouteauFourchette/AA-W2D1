class Manager < Employee

  def initialize(salary, employees)
    @employees = employees
    super(salary)
  end

  def sub_salary
    total_salary = 0
    @employees.each do |employee|
      total_salary += employee.salary
      total_salary += employee.sub_salary if employee.is_a?(Manager)
    end
    total_salary
  end


  def bonus(multiplier)
    @bonus = sub_salary * multiplier
  end

end
