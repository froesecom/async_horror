module CsvImporter
  class ImportActor
    include Celluloid

    def process_row(row)
      puts row
    end

  end
end