# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  index_one = page.body.index(e1)
  index_two = page.body.index(e2)
    
  expect(index_one).to be < index_two
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |rating|
    step "I #{uncheck}check \"ratings_#{rating.strip}\""  
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  # by counting the number of rows 
  # Ref: https://stackoverflow.com/a/37018673
  rows = page.all(:css, 'tbody tr').size
  expect(rows).to eq Movie.count
end
