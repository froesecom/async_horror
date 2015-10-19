require 'celluloid/current'
require 'benchmark'

class Worker
  include Celluloid

  def work(i)
    sleep(1)
    # puts i
  end
end

pool = Worker.pool(:size => 10)
RANGE = (1..10).dup

Benchmark.bm(10) do |x|
  x.report("sync:") {
    RANGE.map { |i| pool.work i }
  }
  x.report("async:") {
    RANGE.map { |i| pool.async.work i }
  }
  x.report("futures:") {
    RANGE.map { |i| pool.future(:work, i) }.map(&:value)
  }
  x.report("ifutures:") {
    RANGE.map { |i| pool.future(:work, i).value }
  }
end