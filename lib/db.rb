require 'sequel'

DB = Sequel.connect(:adapter => 'mysql2', :host => 'localhost', :database => 'transpharm', :user => 'transpharm', :password =>'transpharm', :encoding => 'utf8')
$japmeds = DB[:japmeds]
$meds_ja = DB[:meds_ja]
