require 'sequel'

DB = Sequel.connect(:adapter => 'mysql2', :host => 'localhost', :database => 'transpharm', :user => 'transpharm', :password =>'transpharm', :encoding => 'utf8')

$japmeds = DB[:japmeds]
$meds_ja = DB[:meds_ja]
$japmeds_multi = DB[:japmeds_multi]

$structs = DB[:dict_structs]
$words_with = DB[:words_with]

$subjects = DB[:dict_subjects]
$verbs = DB[:dict_verbs]
$body_parts = DB[:dict_body_parts]
$meds = DB[:dict_meds]
$comparatives = DB[:dict_comparatives]
$adjectives = DB[:dict_adjectives]
$diseases = DB[:dict_diseases]
$med_types = DB[:dict_med_types]
$misc = DB[:dict_misc]

