God.watch do |w|
  w.name = "simple"
  w.start = "ruby /vagrant/backend/test_ruby.rb"
  w.keepalive
  w.log = "godlog.log"
end
