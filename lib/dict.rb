# encoding: UTF-8

def search(search_array)
  
# ----- make word structures ----- #
  @structs = {'subjects'=> [], 'body_parts' => [], 'verbs' => [], 'comparatives' => [], 'meds' => [], 'adjectives' => [], 'diseases' => [], 'med_types' => [], 'misc' => [] }
  make_structs_hash
  
# ----- end make word structures ----- #
# ----- make words_with ----- #
  @words_with = {'desu' => [], 'kakatteimasu' => [], 'hikimashita' => [], 'shiteimasu' => [], 'arimasu' => [], 'dekiteimasu' => []}
  make_words_with_hash
  
  @trans_array = []
  @say_it_array = []

  puts "start: #{search_array.to_s}"
  
# ----- Sentence type checking ----- #
      
  if is_allergy(search_array) # Allergy  - swap "allergic to" with (for eg.) "penicillin" (Japanese) #
    puts "Search array contains \"allergic to\". Rearranging..."
  end
 
 if little_or_lot(search_array) # A little or a lot - puts "sukoshi" or "totemo" before the verb
   puts "Search array contains \"a little\" or \"a lot\". Rearranging..."
 end
 
 if containing(search_array) # When searching for a medicine that contains a chemical or not..
   puts "Search array contains \"containing\" or \"not containing\". Rearranging..."
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
      when "arimasu"
        @trans_array << "があります"
        @say_it_array << "ga arimasu"
      when "desu"
        @trans_array << "です"
        @say_it_array << "desu"
      when "dekiteimasu"
        @trans_array << "ができています"
        @say_it_array << "ga dekite imasu"
      end
    end
  end
end

# ----- End add necessary words ----- #

# ------ Sentence type checking functions ------ #

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
    case key
    when "subjects"
      result = $subjects.filter(:eng=>word).limit(1).select(:jap, :say_it)
    when "body_parts"
      result = $body_parts.filter(:eng=>word).limit(1).select(:jap, :say_it)
    when "verbs"
      result = $verbs.filter(:eng=>word).limit(1).select(:jap, :say_it)
    when "comparatives"
      result = $comparatives.filter(:eng=>word).limit(1).select(:jap, :say_it)
    when "meds"
      result = $meds.filter(:eng=>word).limit(1).select(:jap, :say_it)
    when "adjectives"
      result = $adjectives.filter(:eng=>word).limit(1).select(:jap, :say_it)
    when "diseases"
      result = $diseases.filter(:eng=>word).limit(1).select(:jap, :say_it)
    when "med_types"
      result = $med_types.filter(:eng=>word).limit(1).select(:jap, :say_it)
    when "misc"
      result = $misc.filter(:eng=>word).limit(1).select(:jap, :say_it)
    else
      return "#{word}(no struct)"
    end
    translation = result.first[:jap]
    say_it = result.first[:say_it]
    return translation,say_it
  end
  return word
end

def make_structs_hash
    
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


def display_options(key_string, caps, nilfirst)
  phrases = $structs.filter(:key_string=>key_string)
  phrases = phrases.order(:id).select(:eng)
  
  if key_string == "containing"
    string = "<select name=\"phrase[]\" class=\"containing\">\n"
  else
    string = "<select name=\"phrase[]\">\n"
  end
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

# ------- End fundamental functions ------- #