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
      erb :dict
    end
    
    post '/dict/' do
     
      @phrase = params[:phrase]
      while @phrase.include?("nil")
        @phrase.delete("nil")
      end
      fix_orig_phrase(@phrase)
      @jap_phrase,@say_it_phrase = search(@phrase)
      
      erb :translation, :layout => false
            
    end
    
    get '/dict/addwords/' do
      erb :addwords
    end
    
    post '/dict/addwords/' do
      
      eng = params[:eng]
      jap = params[:jap]
      say_it = params[:say_it]
      dict = params[:dict]
      key_string = params[:key_string]
      necc_words = params[:necc_words]
      
      @success = addwords(eng, jap, say_it, dict, key_string, necc_words)
      
      erb :addwords
    end

end