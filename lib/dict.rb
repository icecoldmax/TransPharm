# encoding: UTF-8

def search(search_array)
  
# ----- make word structures ----- #
  @structs = {}
  make_structs_hash
  
# ----- end make word structures ----- #
# ----- make words_with ----- #
  @words_with = {}
  make_words_with_hash
  
  @trans_array = []
  @say_it_array = []

  puts "start: #{search_array.to_s}"
  
# ----- Sentence type checking ----- #
  if feels_adverb(search_array) # eg "My hands feel cold" - swap the adverb("samuku") with feels("kanjimasu") to get the right order (Japanese)
    puts "Search array contains \"feels\". Rearranging..."
  end      
  if is_allergy(search_array) # Allergy  - swap "allergic to" with (for eg.) "penicillin" (Japanese) #
    puts "Search array contains \"allergic to\". Rearranging..."
  end
 
 if little_or_lot(search_array) # A little or a lot - puts "sukoshi" or "totemo" before the verb
   puts "Search array contains \"a little\" or \"a lot\". Rearranging..."
 end
 
 if containing(search_array) # When searching for a medicine that contains a chemical or not..
   puts "Search array contains \"containing\" or \"not containing\". Rearranging..."
  end
 
 if is_per_time(search_array) # When asking "how many times PER DAY", "per day" needs to go at the front (Japanese) #
   puts "Search array contains \"per day\" or \"per hour\". Rearranging..."
 end
 
  puts "end: #{search_array.to_s}"
# ----- End sentence type checking ----- #

# ----- Do the translating! ----- #  

  translate(search_array)
  
  add_necessary_words(search_array)
  
  return @trans_array.join,@say_it_array.join(" ")
end

# ----- Add necessary words (shite imasu, desu etc.) ----- #

def add_necessary_words(search_array)
  @words_with.each do |k,v|
    if v.include?(search_array.last)
      puts "Phrase requires \"#{k}\". Adding..."
      
      case k
      when "kakatteimasu"
        @trans_array << "にかかっています"
        @say_it_array << "ni kakatte imasu"
      when "hikimashita"
        @trans_array << "をひきました"
        @say_it_array << "o hikimashita"
      when "shiteimasu"
        @trans_array << "をしています"
        @say_it_array << "o shite imasu"
      when "shimasu"
        @trans_array << "がします"
        @say_it_array << "ga shimasu"
      when "arimasu"
        @trans_array << "があります"
        @say_it_array << "ga arimasu"
      when "desu"
        @trans_array << "です"
        @say_it_array << "desu"
      when "dekiteimasu"
        @trans_array << "ができています"
        @say_it_array << "ga dekite imasu"
      when "demasu"
        @trans_array << "がでます"
        @say_it_array << "ga demasu"
      end
    
    end
  end
end

# ----- End add necessary words ----- #

# ------ Sentence type checking functions ------ #

def feels_adverb(search_array)
  if search_array.include?("feel(s)")
    position = search_array.index("feel(s)")
    search_array[position], search_array[position+1] = search_array[position+1], search_array[position]
    return search_array
  end
  return false
end

def is_per_time(search_array)
  if search_array.include?("per day") || search_array.include?("per hour")
    if search_array.include?("per day")
      position = search_array.index("per day")
    elsif search_array.include?("per hour")
      position = search_array.index("per hour")
    end
    per = search_array[position]
    search_array.delete_at(position)
    search_array = search_array.unshift(per)
    return search_array
  end
  return false
end

def is_allergy(search_array)
  if search_array.include?("allergic to") || search_array.include?("not allergic to")
    if search_array.include?("allergic to")
      position = search_array.index("allergic to")
    elsif search_array.include?("not allergic to")
      position = search_array.index("not allergic to")
    end  
    search_array[position], search_array[position+1] = search_array[position+1], search_array[position]
    return search_array
  end
return false
end

def little_or_lot(search_array)
  if search_array.include?("a little") || search_array.include?("a lot")
    if search_array.include?("a little")
      position = search_array.index("a little")
    elsif search_array.include?("a lot")
      position = search_array.index("a lot")
    end
    
    if search_array[position-1] == "hurt(s)"
      search_array[position-1] =  "#{search_array[position-1]} #{search_array[position]}"
      search_array.delete_at(position)      
    end
    
    return search_array
  end
return false    
end

def containing(search_array)
  if (search_array.include?("containing") || search_array.include?("not containing"))
    unless search_array.length == 4
      if search_array.include?("containing")
        search_array.delete("containing")
        @orig_phrase = @orig_phrase.delete("containing")
      elsif search_array.include?("not containing")
        search_array.delete("not containing")
        @orig_phrase = @orig_phrase.delete("not containing")
      end
    else
      search_array[0], search_array[2] = search_array[2], search_array[0]
      return search_array
    end
  end
return false    
end

# ------ End sentence type checking functions ------ #

# ------ Start fundamental functions ------ #

def check_structs(word)
  @structs.each do |key, value|
    if value.include?(word.downcase)
      return key
    end
  end
  return word.upcase unless word.class == Fixnum
end

def translate(search_array)
  
  for word in search_array
    if word.class == String
      translation,say_it = get_jap(check_structs(word), word)
      @trans_array << translation
      @say_it_array << say_it
    else
      @trans_array << "not_string"
    end
  end
end

def get_jap(key, word)
  
  if word.class == String
    
    result = $eng_jap.filter(:eng=>word).limit(1).select(:jap, :say_it)
    unless result.count == 0
      translation = result.first[:jap]
      say_it = result.first[:say_it]
      return translation,say_it
    else
      puts "Not in Dictionary: '#{word}'"
      return "not_found(#{word})"
    end
  end
  return word
end

def make_structs_hash
  
  uniq_structs = $structs.distinct.select(:struct)
  for uniq_struct in uniq_structs
    @structs[uniq_struct[:struct]] = Array.new
  end
  
  structs = $structs.all
  total = 0
  
  for each_struct in structs
    struct = each_struct[:struct]
    eng_word_chunk = each_struct[:eng]
    
    @structs[struct] << eng_word_chunk
    total += 1
  end
    
  puts "Successfully added #{total} structs to @structs hash."
end


def make_words_with_hash

  uniq_words_with = $words_with.distinct.select(:word)
  for uniq_word in uniq_words_with
    @words_with[uniq_word[:word]] = Array.new
  end
  
  words_with = $words_with.all
  total = 0
  
  for each_word in words_with
    word = each_word[:word]
    word_with = each_word[:words_with]
    @words_with[word] << word_with
    total += 1
  end     
  puts "Successfully added #{total} words to @words_with hash."
end


def display_options(key_string, caps, nilfirst, disabled, hidden)
  phrases = $structs.filter(:key_string=>key_string)
  phrases = phrases.order(:id).select(:eng)
  
  string = "<select class=\"#{key_string}\" name=\"phrase[]\""
  
  if key_string == "containing"
    string += " class=\"containing\">\n"
  elsif disabled == "disabled"
    string += " disabled=\"disabled\""
  end
  
  if hidden == "hidden"
    string += "style=\"display: none;\""
  end
  
  string += ">"
  
  string += "<option value=\"nil\"> --- </option>\n" if nilfirst == "nilfirst"
   
  for phrase in phrases
    if caps == "caps"
      phrase[:eng] = phrase[:eng].capitalize
    end
  
    string += "<option value=\"#{phrase[:eng]}\">#{phrase[:eng]}</option>\n"
  end
  
  string += "</select>"
  return string
end

def display_double_options(key_string, second_key_string, caps, nilfirst, off)
  phrases = $structs.filter(:key_string=>key_string)
  phrases2 = $structs.filter(:key_string=>second_key_string)
  phrases = phrases.order(:id).select(:eng)
  phrases2 = phrases2.order(:id).select(:eng)
  
  string = "<select name=\"phrase[]\""
  
  if key_string == "containing"
    string += " class=\"containing\">\n"
  elsif off == "off"
    string += " disabled=\"disabled\""
  end
  string += ">"
  
  string += "<option value=\"nil\"> --- </option>\n" if nilfirst == "nilfirst"
   
  for phrase in phrases
    if caps == "caps"
      phrase[:eng] = phrase[:eng].capitalize
    end
  
    string += "<option value=\"#{phrase[:eng]}\">#{phrase[:eng]}</option>\n"
  end
  
  for phrase2 in phrases2
    if caps == "caps"
      phrase2[:eng] = phrase2[:eng].capitalize
    end
  
    string += "<option value=\"#{phrase2[:eng]}\">#{phrase2[:eng]}</option>\n"
  end
  
  string += "</select>"
  return string
end

def autocomplete_category(category, search_term)
  match_array = []
  results = $eng_jap.filter(:struct=>category)
  results = results.filter(:eng.like(/^#{search_term}/, / #{search_term}/)).order(:eng).select(:eng).limit(10)
  for match in results
    match_array << match[:eng]
  end
return match_array
end
# ------- End fundamental functions ------- #
