require 'benchmark'
require 'benchmark/ips'
require_relative '../lib/array'

def generate_random_data(x)
  Array.new.tap do |a|
    x.times {a << rand(1000)}
  end
end

Benchmark.ips do |x|
  ten      = generate_random_data(10)
  hundred  = generate_random_data(100)
  thousand = generate_random_data(1_000)
  # tenthou  = generate_random_data(10_000)
  # hundthou = generate_random_data(100_000)
  # million  = generate_random_data(1_000_000)
  # fourmillion  = generate_random_data(4_000_000) # square kilo, 2 meter squares

  x.report('ten')      { ten.jenks(5)  }
  x.report('hundred')  { hundred.jenks(5)  }
  x.report('thousand') { thousand.jenks(5) }
  # x.report('tenthou')  { tenthou.jenks(5)  }
  # x.report('hundthou') { hundthou.jenks(5) }
  # x.report('million')  { million.jenks(5) }
  # x.report('fourmillion')  { fourmillion.jenks(5) }
end
