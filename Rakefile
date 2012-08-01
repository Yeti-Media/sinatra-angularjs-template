require 'coffee-script'

namespace :js do
  desc "compile coffee-scripts from ./lib/coffee to ./public"
  task :compile do
    source = "#{File.dirname(__FILE__)}/lib/coffee"
    javascripts = "#{File.dirname(__FILE__)}/public"
    
    Dir.foreach(source) do |cf|
      unless cf == '.' || cf == '..' 
        js = CoffeeScript.compile File.read("#{source}#{cf}") 
        open "#{javascripts}#{cf.gsub('.coffee', '.js')}", 'w' do |f|
          f.puts js
        end 
      end 
    end
  end
end
