require 'spec_helper'

describe 'Announcements concern', type: :controller do
  include CookiesHelper

  controller(ApplicationController) do
    include Readit::Announcements

    def fake_action
      redirect_to '/an_url'
    end
  end

  before do
    routes.draw { get 'fake_action' => 'anonymous#fake_action' }
  end

  describe '#set_announcements' do
    let!(:announcements) { create_list(:announcement, 2) }
    let!(:inactive_announcement) { create(:announcement, is_active: false) }
    let!(:stopped_announcement) { create(:announcement, start_at: 3.days.ago, stop_at: 1.day.ago) }
    let!(:not_started_announcement) { create(:announcement, start_at: 1.day.from_now, stop_at: 3.days.from_now) }

    context 'user has no cookie with read announcements' do
      before { get :fake_action }

      it 'sets all active actual announcements' do
        expect(assigns[:announcements]).to eq(announcements)
      end
    end

    context 'user has cookie with read announcements' do
      let!(:read_announcements) { create_list(:announcement, 2) }

      before do
        store_read_announcements read_announcements.first.id => read_announcements.first.content_digest,
                                 read_announcements.second.id => read_announcements.second.content_digest
        get :fake_action
      end

      it 'sets only unread active actual announcements' do
        expect(assigns[:announcements]).to eq(announcements)
      end
    end

    context 'read announcement content has been updated since user have read it' do
      let!(:read_announcements) { create_list(:announcement, 2) }

      before do
        store_read_announcements read_announcements.first.id => read_announcements.first.content_digest,
                                 read_announcements.second.id => read_announcements.second.content_digest
        read_announcements.first.update_attributes(content: 'Updated content')
        get :fake_action
      end

      it 'sets unread active actual announcements and read announcements that have been changed' do
        expect(assigns[:announcements]).to eq(announcements + [read_announcements.first])
      end
    end
  end
end
