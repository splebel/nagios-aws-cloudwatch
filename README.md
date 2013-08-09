AWS CloudWatch Nagios Plugin
============================

Prerequisites
-------------
- Install required ruby gems

~~~
bundle install
~~~


Installation
------------
- Copy plugins to nagios/plugins directory (/usr/lib/nagios/plugins on Debian)
- Add command definition

~~~
define command {
  command_name check_elb_5xx
  command_line /usr/lib/nagios/plugins/check_elb_5xx -k $ARG1$ -s $ARG2$ -w $ARG3$ -c $ARG4$
}
~~~
