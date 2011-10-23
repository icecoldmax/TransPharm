# encoding: UTF-8

require_relative "transpharm/version"
require_relative "lib/db"
require_relative "lib/hasjap"



def fix_orig_phrase(phrase)   # also fix if "containing" is misused
  if phrase.length == 3
    if phrase.include?("containing")
      phrase.delete("containing")
    elsif phrase.include?("not containing")
      phrase.delete("not containing")
    end
    @phrase.replace(phrase)
  end
  orig_phrase = phrase.clone
  orig_phrase[0] = orig_phrase[0].capitalize
  @orig_phrase = orig_phrase.join(" ")
  @orig_phrase += "." unless @orig_phrase[-1] == "?"
     
end

def memory_check
  mem = `vmmap #{Process.pid}`.squeeze
  pos = mem.index("TOTAL")
  mem = mem[pos+6, 5]
  puts "Current memory usage: #{mem}"
end

module Transpharm

  get '/' do
    erb :index
  end

  get '/medsearch/' do
    erb :medsearch
  end
  
  post '/medsearch/' do
  
    medsearch
    
    puts "Displaying results for search: '#{@search_terms}'  in  '#{@search_params}' (#{@results.count} results)"

    erb :medsearch
    
    end
    
    get '/dict/' do
      memory_check
      
      erb :dict
      
    end
    
    post '/dict/' do
      @phrase = params[:phrase]
      while @phrase.include?("nil")
        @phrase.delete("nil")
      end
      fix_orig_phrase(@phrase)
      @jap_phrase,@say_it_phrase = search(@phrase)
      memory_check
      erb :translation, :layout => false
            
    end
    
    get '/dict/autocomplete/:category' do
      @match_array = []
      category = params[:category]
      search_term = params[:term].downcase
         
      @match_array = autocomplete_category(category, search_term)
            
      puts "Search in '#{category}' | Term: '#{search_term}' | Matches: #{@match_array.join(", ")}."
      memory_check      
      @match_array.to_json
            
    end
    
    get '/dict/addwords/' do
      memory_check
      erb :addwords
    end
    
    post '/dict/addwords/' do
      require './lib/addwords'
      
      eng = params[:eng]
      jap = params[:jap]
      say_it = params[:say_it]
      dict = params[:dict]
      key_string = params[:key_string]
      necc_words = params[:necc_words]
      
      @success = addwords(eng, jap, say_it, dict, key_string, necc_words)
      memory_check
      erb :addwords
    end

end