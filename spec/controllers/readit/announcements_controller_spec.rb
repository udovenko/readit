require 'spec_helper'

describe Readit::AnnouncementsController, type: :controller do
  include CookiesHelper

  describe '#store_reviewed' do
    let(:announcement) { create(:announcement) }
    before { request.env['HTTP_REFERER'] = 'stub referer' }

    shared_examples_for 'controller response' do
      # Change to have_http_status(:found) after updating to Rspec 3:
      specify { expect(response.status).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[:found]) }
    end

    context 'user has no cookie with read announcements ids' do
      let(:mock_digest) { 'b351f2e737b0fe46caa0f9bb7abfa5aa' }

      before do
        post :store_reviewed,
          use_route: :readit,
          id: announcement.id,
          announcement: { content_digest: mock_digest }
      end

      include_examples 'controller response'

      it 'sets cookie with read announcements id' do
        expect(extract_read_announcements).to eq(announcement.id.to_s => mock_digest)
      end
    end

    context 'user already has cookie with just read announcement data' do
      let(:initial_digest) { 'b351f2e737b0fe46caa0f9bb7abfa5aa' }
      let(:new_digest) { 'b351f2e737b0fe46caa0f9b67bb23caf' }

      before do
        store_read_announcements announcement.id => initial_digest
        post :store_reviewed,
          use_route: :readit,
          id: announcement.id,
          announcement: { content_digest: new_digest }
      end

      include_examples 'controller response'

      it 'overwrites read announcements in the cookie' do
        expect(extract_read_announcements).to eq(announcement.id.to_s => new_digest)
      end
    end

    context 'user already has cookie with another read announcement' do
      let(:another_announcement) { create(:announcement) }

      before do
        store_read_announcements another_announcement.id => another_announcement.content_digest
        post :store_reviewed,
          use_route: :readit,
          id: announcement.id,
          announcement: { content_digest: announcement.content_digest }
      end

      include_examples 'controller response'

      it 'stores both read announcements data' do
        expect(extract_read_announcements)
          .to eq(announcement.id.to_s => announcement.content_digest,
                 another_announcement.id.to_s => another_announcement.content_digest)
      end
    end

    context 'user already has cookie with deleted announcements data' do
      let(:mock_digest) { 'b351f2e737b0fe46caa0f9bb7abfa5aa' }
      let(:deleted_announcements) { create_list(:announcement, 2) }

      before do
        store_read_announcements deleted_announcements.first.id => deleted_announcements.first.content_digest,
                                 deleted_announcements.last.id => deleted_announcements.last.content_digest

        deleted_announcements.each(&:destroy)

        post :store_reviewed,
          use_route: :readit,
          id: announcement.id,
          announcement: { content_digest: mock_digest }
      end

      include_examples 'controller response'

      it 'removes deleted announcements from the cookie' do
        expect(extract_read_announcements).to eq(announcement.id.to_s => mock_digest)
      end
    end
  end
end
