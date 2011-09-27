require_relative "transpharm/version"
require_relative "lib/db"
require_relative "lib/hasjap"

module Transpharm

  get '/' do
    erb :index
  end

  post '/medsearch/' do
    
    @search_terms = params[:search_terms]
    @search_params = params[:search_params]
    
    if @search_terms.hasjap?
    
        case @search_params
        when "active_ingredients"
          @results = $meds_ja.filter(:active_ingredients.like("%#{@search_terms}%"))
        when "brand_name"
          @results = $meds_ja.filter(:brand_name.like("%#{@search_terms}%"))
        when "effects"
          @results = $meds_ja.filter(:effects.like("%#{@search_terms}%"))
        when "side_effects"
          @results = $meds_ja.filter(:side_effects.like("%#{@search_terms}%"))
        else
          @results = "I'm a sad Japanese bear"
        end
    
    else
    
      @search_terms = @search_terms.upcase
    
        case @search_params
        when "active_ingredients"
          @results = $japmeds.filter(:search_active_ingredients.like("%#{@search_terms}%"))
        when "brand_name"
          @results = $japmeds.filter(:search_brand_name.like("%#{@search_terms}%"))
        when "effects"
          @results = $japmeds.filter(:search_effects.like("%#{@search_terms}%"))
        when "side_effects"
          @results = $japmeds.filter(:search_side_effects.like("%#{@search_terms}%"))
        else
          @results = "I'm a sad English bear"
        end
    end

    @results = @results.order(:id).select(:id, :brand_name, :active_ingredients, :effects, :dosage, :precautions, :side_effects, :storage, :engurl, :japurl)
    erb :index
  end

end