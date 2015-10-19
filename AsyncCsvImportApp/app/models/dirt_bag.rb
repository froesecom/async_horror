class DirtBag < ActiveRecord::Base
  include CsvImporter

  def self.import_dirtbags_async
    
    pool = CsvImporter::ImportActor.pool(size: 5)
    SmarterCSV.process("public/all_the_things.csv").map do |row|
      pool.future(:process_row, row)
    end.map(&:value)
    ActiveRecord::Base.clear_active_connections!
    
  end
  
  def self.import_dirtbags_insync
    pool = CsvImporter::ImportActor.pool(size: 5)
    SmarterCSV.process("public/all_the_things.csv") do |row|
      pool.process_row(row)
    end
  end

end
