require_relative "transpharm/version"
require "rubygems"
require "sinatra"
require "erb"
require "sequel"
require_relative "db"


module Transpharm

  get '/' do
    erb :index
  end
  
  post '/medsearch/' do
    @search_terms = params[:search_terms].upcase
    @search_params = params[:search_params]
   
    case @search_params
    when "active_ingredients"
      @results = $japmeds.filter(:search_active_ingredients.like("%#{@search_terms}%"))
    when "brand_name"
      @results = $japmeds.filter(:search_brand_name.like("%#{@search_terms}%"))
    else
      @results = "I'm a sad bear"
    end
        
    @results = @results.order(:id).select(:id, :brand_name, :active_ingredients, :effects, :dosage, :precautions, :side_effects, :storage, :engurl, :japurl)
    erb :index
  end  

end