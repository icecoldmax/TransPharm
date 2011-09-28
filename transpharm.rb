require_relative "transpharm/version"
require_relative "lib/db"
require_relative "lib/hasjap"

module Transpharm

  get '/' do
    erb :index
  end

  post '/medsearch/' do
    
    
    @orig_search_terms = params[:search_terms]
    
    # So I can redisplay the entered search terms (not upcased) in the form without using ajax :P
    
    @search_terms = @orig_search_terms
    
    @search_params = []
    for param in params[:search_params] do
      @search_params << param
    end
        
    if @search_terms.hasjap?
      
      if @search_params.length == 4
      
        @results = $meds_ja.filter("#{@search_params[0]} LIKE ? OR #{@search_params[1]} LIKE ? OR #{@search_params[2]} LIKE ? OR #{@search_params[3]} LIKE ?", "%#{@search_terms}%", "%#{@search_terms}%", "%#{@search_terms}%", "%#{@search_terms}%")      
      
      elsif @search_params.length == 3
              
        @results = $meds_ja.filter("#{@search_params[0]} LIKE ? OR #{@search_params[1]} LIKE ? OR #{@search_params[2]} LIKE ?", "%#{@search_terms}%", "%#{@search_terms}%", "%#{@search_terms}%")
       
       elsif @search_params.length == 2
         
         @results = $meds_ja.filter("#{@search_params[0]} LIKE ? OR #{@search_params[1]} LIKE ?", "%#{@search_terms}%", "%#{@search_terms}%")
               
      elsif @search_params.length == 1
       
        @results = $meds_ja.filter("#{@search_params[0]} LIKE ?", "%#{@search_terms}%")
       
      else
        p "Too many or too few params!!"
      end
            
    else
            
      if @search_params.length == 4
      
        @results = $japmeds.filter("#{@search_params[0]} LIKE ? OR #{@search_params[1]} LIKE ? OR #{@search_params[2]} LIKE ? OR #{@search_params[3]} LIKE ?", "%#{@search_terms}%", "%#{@search_terms}%", "%#{@search_terms}%", "%#{@search_terms}%")      
      
      elsif @search_params.length == 3
              
        @results = $japmeds.filter("#{@search_params[0]} LIKE ? OR #{@search_params[1]} LIKE ? OR #{@search_params[2]} LIKE ?", "%#{@search_terms}%", "%#{@search_terms}%", "%#{@search_terms}%")
       
       elsif @search_params.length == 2
         
         @results = $japmeds.filter("#{@search_params[0]} LIKE ? OR #{@search_params[1]} LIKE ?", "%#{@search_terms}%", "%#{@search_terms}%")
               
      elsif @search_params.length == 1
       
        @results = $japmeds.filter("#{@search_params[0]} LIKE ?", "%#{@search_terms}%")
       
      else
        p "Too many or too few params!!"
      end
          
    end
  
            @results = @results.order(:id).select(:id, :brand_name, :active_ingredients, :effects, :dosage, :precautions, :side_effects, :storage, :engurl, :japurl)
            erb :index
    end

end