class DirtBag < ActiveRecord::Base
  include CsvImporter
  include Celluloid::Notifications

  def import_dirtbags_async
    pool = CsvImporter::ImportActor.pool(size: 5)
    SmarterCSV.process("public/all_the_things.csv").map do |row|
      pool.future(:process_row, row)
      publish "done!", "Whatevs"
      pool.process_row(row)
    end.map(&:value) 
  end
  
  def import_dirtbags_insync
    pool = CsvImporter::ImportActor.pool(size: 5)
    SmarterCSV.process("public/all_the_things.csv") do |row|
      pool.process_row(row)
      publish "done!", "Whatevs"
    end
  end

end


class Observer
  include Celluloid
  include Celluloid::Notifications

  attr_accessor :successes

  def initialize
    subscribe "done!", :on_completion
    @successes = 0
  end

  def on_completion(*args)
    puts "finished, returned #{args.inspect}"
    @successes += 1
  end
end