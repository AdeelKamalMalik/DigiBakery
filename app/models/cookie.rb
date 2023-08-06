class Cookie < ApplicationRecord
  belongs_to :storage, polymorphic: :true

  enum :state, { scheduled: 0, cooking: 1, ready_to_retrieve: 2 }

  validates :storage, :fillings, presence: true
  after_create :prepare_cookies

  def ready?
    ready_to_retrieve?
  end

  def prepare_cookies
    PrepareCookieJob.perform_later(id)
  end
end
