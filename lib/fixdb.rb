require 'sequel'
require 'mysql2'

@DB = Sequel.connect(:adapter => 'mysql2', :host => 'localhost', :database => 'transpharm', :user => 'transpharm', :password =>'transpharm', :encoding => 'utf8')

@meds_ja = @DB[:meds_ja]

@results = @meds_ja.filter(:active_ingredients.like('%（%'))
@results = @results.select(:id, :active_ingredients)


for i in @results
  @id = i[:id].to_s
  @ings = i[:active_ingredients].to_s
  print "\'#{@ings}\' is becoming "
  @ings = @ings.split("（")
  print "\'#{@ings.first}\'\n"
  puts "----------"
  
  @meds_ja.filter('id = ?', @id).update(:active_ingredients => @ings.first.to_s)
end

  