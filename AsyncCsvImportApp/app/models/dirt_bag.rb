class DirtBag < ActiveRecord::Base
  include CsvImporter

  attr_accessor :successes, :failures

  after_initialize :init 

  def import_dirtbags_async
    pool = CsvImporter::ImportActor.pool(size: 5)
    SmarterCSV.process("public/all_the_things.csv").map do |row|
      pool.future(:process_row, row)
    end.map(&:value) 
  end
  
  def import_dirtbags_insync
    pool = CsvImporter::ImportActor.pool(size: 5)
    SmarterCSV.process("public/all_the_things.csv") do |row|
      pool.process_row(row)
    end
  end

  private
  def init 
    self.successes = 0
    self.failures  = []
  end

end
