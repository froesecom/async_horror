
require 'smarter_csv'
require 'celluloid/current'
require 'benchmark'
require_relative 'import_manager'
require_relative 'import_actor'

def do_all_the_things_async_from_pools
  pool    = ImportActor.pool(size: 5)
  SmarterCSV.process("all_the_things.csv") do |row|
    pool.async.process_row(row)
  end
end

def do_all_the_things_async
  SmarterCSV.process("all_the_things.csv") do |row|
    actor = ImportActor.new
    actor.async.process_row(row)
    actor.terminate
  end
end

def do_all_the_things_insync
  SmarterCSV.process("all_the_things.csv") do |row|
    actor = ImportActor.new
    actor.process_row(row)
    actor.terminate
  end
end



puts Benchmark.measure { do_all_the_things_async_from_pools }
puts Benchmark.measure { do_all_the_things_async }
puts Benchmark.measure { do_all_the_things_insync }