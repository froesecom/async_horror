module CsvImporter
  require 'celluloid/current'
  class ImportActor
    include Celluloid

    def process_row(row)
      DirtBag.create(row)
    end

  end
end