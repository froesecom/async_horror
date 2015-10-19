module CsvImporter
  require 'celluloid/current'
  class ImportActor
    include Celluloid

    def process_row(row)
      ActiveRecord::Base.connection_pool.with_connection do
        DirtBag.create(row)
      end
    end

  end
end