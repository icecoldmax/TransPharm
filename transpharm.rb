require_relative "transpharm/version"
require_relative "lib/db"
require_relative "lib/hasjap"

module Transpharm

  get '/' do
    erb :index
  end

  post '/medsearch/' do
    
    @search_terms = params[:search_terms]
        
    @search_params = []
    @orig_search_params = []
    for param in params[:search_params] do
      @search_params << param
      @orig_search_params << param
    end
    
    if @search_terms.hasjap?
      @search_params.map! { |word| "#{word}_ja" }
    else
      @search_params.map! { |word| "#{word}_en" }
    end
      
      if @search_params.length == 4
          @results = $japmeds_multi.filter("#{@search_params[0]} LIKE ? OR #{@search_params[1]} LIKE ? OR #{@search_params[2]} LIKE ? OR #{@search_params[3]} LIKE ?", "%#{@search_terms}%", "%#{@search_terms}%", "%#{@search_terms}%", "%#{@search_terms}%")      
      
      elsif @search_params.length == 3
          @results = $japmeds_multi.filter("#{@search_params[0]} LIKE ? OR #{@search_params[1]} LIKE ? OR #{@search_params[2]} LIKE ?", "%#{@search_terms}%", "%#{@search_terms}%", "%#{@search_terms}%")
       
       elsif @search_params.length == 2
          @results = $japmeds_multi.filter("#{@search_params[0]} LIKE ? OR #{@search_params[1]} LIKE ?", "%#{@search_terms}%", "%#{@search_terms}%")
               
      elsif @search_params.length == 1
          @results = $japmeds_multi.filter("#{@search_params[0]} LIKE ?", "%#{@search_terms}%")
       
      else
        p "Too many or too few params!!"
      end
          
      @results = @results.order(:id).select(:id, :brand_name_en, :brand_name_ja, :active_ingredients_en, :active_ingredients_ja, :effects_en, :effects_ja, :dosage_en, :dosage_ja, :precautions_en, :precautions_ja, :side_effects_en, :side_effects_ja, :storage_en, :storage_ja, :engurl, :japurl)

      puts "Displaying results for search: '#{@search_terms}'  in  '#{@search_params}' (#{@results.count} results)"

      erb :index
      
    end

end