DB = Sequel.connect(:adapter => 'mysql2', :host => 'localhost', :database => 'dbname', :user => 'username', :password =>'password', :encoding => 'utf8')
$japmeds = DB[:japmeds]