
require 'smarter_csv'
require 'celluloid/current'
require 'benchmark'
require_relative 'import_manager'
require_relative 'import_actor'

def do_all_the_things_with_futures
  pool    = ImportActor.pool(size: 100)
  100.times.map do |row|
    pool.future(:process_row,row)
  end.map(&:value)
end

def do_all_the_things_insync_from_pools
  pool    = ImportActor.pool(size: 100)
  100.times do |row|
    pool.process_row(row)
  end
end

def do_all_the_things_insync
  100.times do |row|
    actor = ImportActor.new
    actor.async.process_row_and_terminate(row)
  end
end

puts Benchmark.measure { do_all_the_things_with_futures}
puts Benchmark.measure { do_all_the_things_insync_from_pools }
puts Benchmark.measure { do_all_the_things_insync }