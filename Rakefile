require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end

desc 'Resets the database'
task :reset do
  ENV['STEP'] = '100' # <-------------- declare your environment variable
  Rake::Task["db:rollback"].invoke
  Rake::Task["db:migrate"].invoke
  Rake::Task["db:seed"].invoke
end
