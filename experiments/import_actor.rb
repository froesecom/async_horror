class ImportActor
  include Celluloid

  def process_row(row)
    #100000.times {|n| n}
    sleep 1
    puts row
  end

  def process_row_and_terminate(row)
    #100000.times {|n| n}
    sleep 1
    puts row
  end

end