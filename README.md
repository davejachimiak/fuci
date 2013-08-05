# Fuci
[![Build Status](https://travis-ci.org/davejachimiak/fuci.png?branch=master)](https://travis-ci.org/davejachimiak/fuci)

A base gem providing the general case for running CI failures locally.

## Installation

Add this line to your fuci extension's Gemspec:

```ruby
Gem::Specification.new do |spec|
  ...
  spec.add_dependency 'fuci', '~> 0.3'
  ...
end
```

## Known server extensions
* [Fuci::Travis](https://github.com/davejachimiak/fuci-travis)

## Native command-line options
Run the failed tests from your last `fuci` command.

```sh
$ fuci --last
```
or
```sh
$ fuci -l
```

## Usage
### Creating server extensions
#### Configuring Fuci base with the server
Somewhere in the required code of the server extension, the server must
be set like so:
```ruby
Fuci.configure do |fu|
  fu.server = Fuci::MyCiAgent::ServerClass
end
```
or
```ruby
module Fuci
  configure do |fu|
    fu.server = Fuci::MyCiAgent::ServerClass
  end

  module MyCiAgent
    ...
    ...
  end
end
```

The ServerClass in this example must be an initializable constant whose
instance implements the server interface.

#### The server interface
The `Fuci::Server` interface class that tells what the runner
expects of server extensions. As of this version, it expects two
methods: `#build_status` and `#fetch_log`. See that file for more
details on what they should return.

#### The binstub
Server extensions should ship with their own binstub. `fuci` is
preffered. It's short and easy to type. To avoid possible conflicts
between local server extensions, prefer that users execute `bundle
binstubs <server-extension>`.

Fuci binstubs should do the following:
* Require the extension
* Load a configuration file, if necessary
* Call `Fuci.run`

### Creating tester extensions
Coming soon...
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
