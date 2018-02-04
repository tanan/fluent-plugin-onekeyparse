# fluent-plugin-onekeyparse

[Fluentd](https://fluentd.org/) filter plugin to parse values of your selected key.

## Installation

### RubyGems

```
$ gem install fluent-plugin-onekeyparse
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-onekeyparse"
```

And then execute:

```
$ bundle
```

## Configuration

| name | type | description |
|:-----|:-----|:------------|
| in_format | string | parser format |
| in_key | string | a key you want to parse |
| out_record_keys | string | output record keys |
| out_record_types | string | output record types |

A sample configuration is following.

```
<filter>
  @type onekeyparse
  in_format ^(?<val1>[^ ]*) (?<val2>[^ ]*) (?<val3>[^ ]*)$
  in_key key1
  out_record_keys val1,val2,val3
  out_record_types string,string,string
</filter>
```

You can generate configuration template:

```
$ fluent-plugin-config-format filter onekeyparse
```

You can copy and paste generated documents here.

## Copyright

* Copyright(c) 2018- tanan
* License
  * Apache License, Version 2.0
