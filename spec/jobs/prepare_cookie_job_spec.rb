require 'rails_helper'

RSpec.describe PrepareCookieJob, type: :job do
  describe '#perform' do
    let(:cookie) { create(:cookie) }

    it 'updates the cookie state and broadcasts the updated cookie' do
      expect(ActionCable.server).to receive(:broadcast).with(
        "cookies_channel", {:cookie=>"<div id=\"cookies#{cookie.id}\">\n  <span>1 cookie with MyString\n      (Your Cookie is Ready)\n  </span>\n</div>\n",
         id: cookie.id, :oven_busy=> false, :oven_id=> cookie.storage.id,
         :oven_actions => "<form class=\"button_to\" method=\"post\" action=\"/ovens/#{cookie.storage.id}/empty\"><button class=\"button tiny\" type=\"submit\">Retrieve Cookie</button></form>\n<br />\n\n<form class=\"button_to\" method=\"get\" action=\"/ovens/#{cookie.storage.id}/cookies/new\"><button class=\"button\" disabled=\"disabled\" type=\"submit\">Prepare Cookie</button></form>\n"})
      
      expect { PrepareCookieJob.perform_now(cookie.id) }.to change { cookie.reload.state }.to 'ready_to_retrieve'
    end
  end
end
