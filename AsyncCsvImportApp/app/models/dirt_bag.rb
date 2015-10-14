class DirtBag < ActiveRecord::Base
  include CsvImporter

  def self.import_dirtbags_async
    # pool = CsvImporter::ImportActor.pool(size: 100)
    
    # .process_row("blah")
  end
  
  def self.import_dirtbags_insync
    # CsvImporter::ImportActor.new.process_row("blah")
  end

end
