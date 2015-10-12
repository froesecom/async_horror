class ImportManager
  include Celluloid

  trap_exit :capture_dem_errors

  def capture_dem_errors(actor, reason)
    "#{actor.inspect} has died because of a #{reason.class}"
  end

end