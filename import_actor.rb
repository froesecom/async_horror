class ImportActor
  include Celluloid

  def process_row(row)
    100000.times {|n| n}
  end

  def process_row_and_terminate(row)
    100000.times {|n| n}
  end

end