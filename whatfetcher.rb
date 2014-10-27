# Whatfetcher
#  alex standke
#
# Fetches the most recent torrents in your default torrent view page.
#
# Run with 'ruby whatfetcher.rb USERNAME PASSWORD'

if ARGV[0].nil? || ARGV[1].nil?
  puts "Run with 'ruby orderfetcher.rb USERNAME PASSWORD'"
  exit
end

require 'rubygems'
require 'mechanize'
require 'logger'

mech = Mechanize.new

mech.user_agent_alias = 'Linux Firefox'

# Login
page = mech.get('http://what.cd/')
page = mech.click page.link_with(text: /Log In/i)
form = page.forms[0]
form.set_fields({username: ARGV[0], password: ARGV[1]})
page = form.submit form.buttons.first

page = mech.click page.link_with(:text => /Torrents/i)

# Download the torrents
page.links_with(text: 'DL').each do |l|
  torrent = mech.click l
  if File.exists?('torrents/' + torrent.filename)
    puts "Skipping #{torrent.filename}"
  else
    puts "Downloading #{torrent.filename}"
    File.open('torrents/' + torrent.filename, 'wb') {|f| f << torrent.body}
  end
end
