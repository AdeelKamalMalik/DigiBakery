require 'rails_helper'

describe Cookie do
  subject { Cookie.new(fillings: 'Chocolate Chip') }
  let(:oven) { create(:oven) }

  describe "associations" do
    it { should belong_to(:storage) }
  end

  describe "validations" do
    it { should validate_presence_of(:storage) }
    it { should validate_presence_of(:fillings) }
  end

  describe "enums" do 
    it { should define_enum_for(:state).
          with([:scheduled, :cooking, :ready_to_retrieve]) }
  end

  describe "callbacks" do
    before { ActiveJob::Base.queue_adapter = :test }
    context 'after create #prepare_cookies' do
      it 'should enqueue PrepareCookieJob' do
        subject.storage = oven
        expect { subject.save! }.to have_enqueued_job(PrepareCookieJob).with(subject.id)
      end
    end
  end
end
