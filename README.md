# Jenks

Implementation of Jenks' Natural Breaks Algorithm in Ruby. I converted it from [Tom MacWright's original Javascript](github.com/tmcw/simple-statistics) into Ruby, and then optimized it for Ruby's strengths.

## Installation

Add this line to your application's Gemfile:

    gem 'jenks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jenks

## Usage

Jenks adds a single method, #jenks to the Array class.

    data = (1..20).to_a + (41..60).to_a + (81..100).to_a # Three distinct sets in one array
    data.jenks(3) # [1,20,60,100]

## Contributing

1. Fork it ( https://github.com/[my-github-username]/jenks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
