DataMapper.setup(:default, 'sqlite:///projects/expensesAPI/expenses.db')
class Expense
  include DataMapper::Resource

  property :id,               Serial
  property :date,             DateTime
  property :type,             String
  property :subtype,          String
  property :description,      String
  property :value,            Decimal
  property :deleted,          Boolean

end
DataMapper.auto_upgrade!
