require 'bundler/setup'
require 'dotenv'
require 'sinatra'
require 'prowl'

Dotenv.load

trap('TERM') do
  Process.kill('INT', $$)
end

get '/' do
  haml :index
end

post '/start' do
  @@thread = Thread.new do
    loop do
      puts "Start"
      puts ENV['PROWL_API_KEY']
      Prowl.add(
        :apikey => ENV['PROWL_API_KEY'],
        :application => "Fartleker",
        :event => "FAST",
        :description => "Go Fast Dude",
        :priority => -1
      )
      sleep 60 * 4 # Run fast for 4 minutes
      Prowl.add(
        :apikey => ENV['PROWL_API_KEY'],
        :application => "Fartleker",
        :event => "SLOW",
        :description => "Slow down slugger",
        :priority => -2
      )
      sleep 60 # Run slow for 1 minute
    end
  end

  redirect to('/')
end

post '/end' do
  @@thread.kill

  redirect to('/')
end
