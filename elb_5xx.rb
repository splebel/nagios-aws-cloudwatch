#!/usr/bin/env ruby
require 'AWS'
require 'rubygems'
require 'getopt/std'

ACCESS_KEY_ID = ''
SECRET_ACCESS_KEY = ''

$cw = AWS::Cloudwatch::Base.new(:access_key_id => ACCESS_KEY_ID, :secret_access_key => SECRET_ACCESS_KEY)

$timeperiod = 300
http2xx = 0
http5xx = 0
warning = 8
critical = 10

opt = Getopt::Std.getopts("c:w:l:")

if opt["c"]
  critical = opt["c"].to_i
end

if opt["w"]
  warning = opt["w"].to_i
end

def get_stats(httpcode)
  res = $cw.get_metric_statistics(:namespace => "AWS/ELB", :measure_name => httpcode, :statistics => "Sum", :period => $timeperiod, :start_time => (Time.now() - $timeperiod) )
  begin
    ret = res['GetMetricStatisticsResult']['Datapoints']['member'].first['Sum'].to_i
  rescue
    ret = 0
  end
  return ret
end

http2xx = get_stats('HTTPCode_Backend_2XX')
http5xx = get_stats('HTTPCode_Backend_5XX')

rate = http5xx * 100 / http2xx
status = 'Unknown!'
exitcode = 3

if rate < warning
  status = 'OK!'
  exitcode = 0
end
if rate >= warning
  status = 'Warning!'
  exitcode = 1
end
if rate >= critical
  status = 'Critical!'
  exitcode = 2
end

puts "#{status} #{rate}% - 2xx:#{http2xx} 5xx:#{http5xx}"
exit exitcode

