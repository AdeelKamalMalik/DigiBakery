class CookiesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "cookies_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
