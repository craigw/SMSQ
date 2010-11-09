require 'bundler'
Bundler.setup

require 'smqueue'
require 'yajl/json_gem'
host = ARGV.shift
name = ARGV.shift
message = ARGV.shift.strip
numbers = ARGV
notification = {
  :message => message,
  :destination_numbers => numbers
}

puts "Message: \"#{message}\""
puts "Numbers: #{numbers.join(', ')}"
puts "Notification: #{JSON.generate(notification)}"
puts "Are you sure? y/N"
if STDIN.gets.strip == "y"
  print "Connecting to queue (host: #{host}, name: #{name})... "
  queue = SMQueue(:configuration => {
    :host => host,
    :name => name,
    :adapter => :StompAdapter
  })
  puts "done"
  json = JSON.generate notification
  print "Sending message to queue #{json}... "
  queue.put json
  puts "done"
else
  puts "You must answer exactly 'y' to send the message"
  exit 1
end
