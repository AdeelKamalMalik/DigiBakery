class PrepareCookieJob < ApplicationJob
  attr_reader :cookie, :oven
  queue_as :cookies

  def perform(id)
    @cookie = Cookie.find_by(id: id)
    return unless cookie

    cookie.cooking!
    @oven = cookie.storage
    sleep 180 # preparing cookie for 3 minutes (180 seconds)

    cookie.ready_to_retrieve!

    if oven.cookies.where(state: [:cooking, :scheduled]).blank?
      oven.update(busy: false)
    end

    broadcast
  end

  private

  def cookie_partial
    ApplicationController.render(
      partial: 'cookies/cookie',
      locals: { cookie: cookie }
    )
  end

  def oven_actions
    ApplicationController.render(
      partial: 'ovens/actions',
      locals: { oven: oven }
    )
  end

  def broadcast
    ActionCable.server.broadcast('cookies_channel',
      { cookie: cookie_partial, id: cookie.id, oven_id: oven.id,
       oven_busy: oven.busy, oven_actions: oven_actions }
    )
  end
end
