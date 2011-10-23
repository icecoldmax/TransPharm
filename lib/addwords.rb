# encoding: UTF-8

def addwords(eng, jap, say_it, dictionary, key_string, necc_words)

  subjects = $DB[:dict_subjects]
  verbs = $DB[:dict_verbs]
  body_parts = $DB[:dict_body_parts]
  meds = $DB[:dict_meds]
  comparatives = $DB[:dict_comparatives]
  adjectives = $DB[:dict_adjectives]
  diseases = $DB[:dict_diseases]
  med_types = $DB[:dict_med_types]
  misc = $DB[:dict_misc]
  questions = $DB[:dict_questions]
  time = $DB[:dict_time]
  symptoms = $DB[:dict_symptoms]
  adverbs = $DB[:dict_adverbs]

  case dictionary
  when "adjectives"
    adjectives.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  when "body_parts"
    body_parts.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  when "comparatives"
    comparatives.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  when "diseases"
    diseases.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  when "med_types"
    med_types.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  when "meds"
    meds.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  when "questions"
    questions.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  when "misc"
    misc.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  when "subjects"
    subjects.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  when "verbs"
    verbs.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  when "time"
    time.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  when "symptoms"
    symptoms.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  when "adverbs"
    adverbs.insert(:eng => eng.downcase, :jap => jap, :say_it => say_it)
  else
    puts "Dictionary not found."
    return false
  end
  
  $structs.insert(:eng => eng, :struct => dictionary, :key_string => key_string)
  
  unless necc_words == "nothing"
    $words_with.insert(:word => necc_words, :words_with => eng.downcase)
  end
  
  return "<p>Successfully added:<br />
          '#{eng}',<br />
          '#{jap}',<br />
          '#{say_it}'<br />
           <br />
           to '#{dictionary}' dictionary,<br />
           added it to structs with they key_string: '#{key_string}',<br />
           and added '#{necc_words}' to the words_with hash.</p>"
end