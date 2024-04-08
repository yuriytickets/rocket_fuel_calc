require 'optparse'

KOEFS = {
  land: [0.033, 42],
  launch: [0.042, 33]
}.freeze

def calc_fuel(mass, gravity, action)
  fuel_required = mass * gravity * KOEFS.dig(action, 0) - KOEFS.dig(action, 1)
  return 0 if fuel_required.negative?

  fuel_required + calc_fuel(fuel_required, gravity, action)
end

def launch(mass, route)
  puts "🚀 #{mass} Kg"
  full_mass = route.reverse.inject(mass) do |result, element|
    action, gravity = element
    result + calc_fuel(result, gravity, action)
  end

  print "⛽︎"*((full_mass - mass) / 10_000).floor
  puts "Fuel needed: #{full_mass - mass}"
end

def test
  puts "🛸"
  puts <<APOLLO_11
  Apollo 11:
  path: launch Earth, land Moon, launch Moon, land Earth
  weight of equipment: 28801 kg
  [weight of fuel expected]: 51898 kg
  ACTUAL RESULT:
APOLLO_11
  launch(28801, [[:launch, 9.807], [:land, 1.62], [:launch, 1.62], [:land, 9.807]])

  puts "🛸"*2
  puts <<MARS
  Mission on Mars:
  path: launch Earth, land Mars, launch Mars, land Earth
  weight of equipment: 14606 kg
  [weight of fuel expected]: 33388 kg
  ACTUAL RESULT:
MARS
  launch(14606, [[:launch, 9.807], [:land, 3.711], [:launch, 3.711], [:land, 9.807]])

  puts "🛸"*3
  puts <<PASSENGER
  Passenger ship:
  path: launch Earth, land Moon, launch Moon, land Mars, launch Mars, land Earth
  weight of equipment: 75432 kg
  [weight of fuel expected]: 212161 kg
  ACTUAL RESULT:
PASSENGER

  launch(75432, [[:launch, 9.807], [:land, 1.62], [:launch, 1.62], [:land, 3.711], [:launch, 3.711], [:land, 9.807]])
end

options = {}
parser = OptionParser.new
parser.banner = "Usage: $> ruby rocket.rb [options]"
parser.on('-m', '--mass FLOAT', Float, "Equipment Mass, Kg")
parser.on("-r", "--route ARR", Array, 'Route as launch,9.807,land,1.62') do |r|
  options[:route] = r.each_slice(2).map do |s|
    [s[0].to_sym, s[1].to_f]
  end
end
parser.on('-t', '--test', 'Test mode')
parser.parse!(into: options)

if options[:test]
  test
else
  launch(options[:mass], options[:route])
end
