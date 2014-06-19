# This example logs a user in to rubyforge and prints out the body of the
# page after logging the user in.
require 'rubygems'
require 'mechanize'
require 'logger'

# Create a new mechanize object
mech = Mechanize.new

# Login
page = mech.get('http://what.cd/')
page = mech.click page.link_with(text: /Log In/i) # Click the login link
form = page.forms[0] # Select the first form
form.set_fields({username: ARGV[0], password: ARGV[1]})
page = form.submit form.buttons.first

page = mech.click page.link_with(:text => /Torrents/i) # Click the login link

# Download the torrents
page.links_with(text: 'DL').each do |l|
  torrent = mech.click l
  if File.exists?(torrent.filename)
    puts "Skipping #{torrent.filename}"
  else
    puts "Downloading #{torrent.filename}"
    File.open(torrent.filename, 'wb') {|f| f << torrent.body}
  end
end
