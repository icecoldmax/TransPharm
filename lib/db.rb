require 'sequel'

$DB = Sequel.connect(:adapter => 'mysql2', :host => 'localhost', :database => 'transpharm', :user => 'transpharm', :password =>'transpharm', :encoding => 'utf8')


$japmeds_multi = $DB[:japmeds_multi]

$structs = $DB[:dict_structs]
$words_with = $DB[:words_with]

$eng_jap = $DB[:dict_eng_jap]

# $japmeds = DB[:japmeds]
# $meds_ja = DB[:meds_ja]