DataMapper.setup(:default, 'sqlite:///projects/expensesAPI/expenses.db')
class Expense
  include DataMapper::Resource

  property :id,               Serial
  property :date,             DateTime, :required => true
  property :type,             String, :required => true
  property :subtype,          String, :required => true
  property :description,      String, :required => true
  property :value,            Float, :required => true
  property :deleted,          Boolean, :required => true

end
DataMapper.auto_upgrade!
DataMapper.finalize
