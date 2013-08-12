# config/unicorn.rb
if ENV["RAILS_ENV"] == "development"
  worker_processes 1
else
  worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
end


timeout 30
preload_app true

before_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  # defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  # defined?($redis) and $redis.client.disconnect
end  

after_fork do |server, worker|

  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  # defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
  # defined?($redis) and $redis.client.connect

end