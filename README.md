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

1. Fork it ( https://github.com/judy/jenks/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Install development gems (`bundle install`)
1. Benchmark with `ruby benchmarks/array_benchmark.rb`
1. Fix bugs or add a feature.
1. Verify everything passes (`rspec`)
1. Benchmark again, leave the code as fast or faster than when you forked.
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new pull request.
