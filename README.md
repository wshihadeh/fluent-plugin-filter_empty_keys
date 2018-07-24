# fluent-plugin-filter_typecast

A Fluentd filter plugin to filter empty keys

## Requirements

Fluentd >= v0.12

## Install

Use RubyGems:

```
gem install fluent-plugin-filter_empty_keys
```

## Configuration Examples

```
<source>
  type dummy
  tag dummy
  dummy {"field1":"","field2":"2","field3":"2013-02-12 22:04:14 UTC","field4":"","field5":"a,b,c"}
</source>

<filter **>
  type empty_keys
</filter>

<match **>
  type stdout
</match>
```

You should see casted records:
```
dummy {"field2":"2","field3":"2013-02-12 22:04:14 UTC","field5":"a,b,c"}
```

```
<source>
  type dummy
  tag dummy
  dummy {"field0":0,"field1":"","field2":"Undefined","field3":"2013-02-12 22:04:14 UTC","field4":"","field5":"a,b,c"}
</source>

<filter **>
  type empty_keys
  empty_keys field0:0,field2:Undefined
</filter>

<match **>
  type stdout
</match>
```

You should see casted records:
```
dummy {"field3":"2013-02-12 22:04:14 UTC","field5":"a,b,c"}
```

## ChangeLog

See [CHANGELOG.md](CHANGELOG.md) for details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2015 Naotoshi Seo. See [LICENSE](LICENSE) for details.
