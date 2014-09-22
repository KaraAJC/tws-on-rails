class UpdateTeaTime
  class << self
    def call(tea_time, update)
      old_host = tea_time.host
      host_change = host_changed?(tea_time, update)
      update = tea_time.update(update)

      if update && host_change
        TeaTimeMailer.delay.host_changed(tea_time.id, old_host.id)
      end

      return update
    end

    private
    def host_changed?(tea_time, update)
      tea_time.host.id != update[:user_ud]
    end
  end
end
