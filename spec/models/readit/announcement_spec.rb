require 'spec_helper'

describe Readit::Announcement do
  describe 'base validations' do
    subject { build(:announcement) }
    before do
      # To avoid shoulda matchers failure:
      subject.stub(:start_and_stop_datetime_order).and_return(true)
    end

    it { should validate_presence_of :content }
    it { should validate_presence_of :start_at }
    it { should validate_presence_of :stop_at }
  end

  describe 'callbacks' do
    subject { build(:announcement, content: 'some content') }

    describe 'calculate content digest before save' do
      it 'triggers the callback' do
        expect(subject).to receive(:calculate_content_digest)
        subject.save
      end

      specify 'callback calculates content digest' do
        subject.save
        expect(subject.content_digest).to eq(Digest::MD5.hexdigest(subject.content))
      end
    end
  end

  describe 'start_at and stop_at datetime order validations' do
    subject { build(:announcement, stop_at: Time.current - 1.day) }

    it { should_not be_valid }
    it 'has start time grater or equal to end time error' do
      subject.valid?
      expect(subject.errors[:base]).to include\
        I18n.t!(:start_time_grater_or_equal_to_end_time,
          scope: 'activerecord.errors.models.readit/announcement')
    end
  end

  describe '.active' do
    let!(:active_announcement) { create(:announcement, is_active: true) }
    let!(:inactive_announcement) { create(:announcement, is_active: false) }

    it 'returns only present products' do
      expect(described_class.active).to eq([active_announcement])
    end
  end

  describe '.actual' do
    let!(:stopped_announcement) do
      create(:announcement,
        start_at: Time.current - 3.days,
        stop_at: Time.current - 1.day)
    end
    let!(:actual_announcement) do
      create(:announcement,
        start_at: Time.current - 1.day,
        stop_at: Time.current + 1.day)
    end
    let!(:not_started_announcement) do
      create(:announcement,
        start_at: Time.current + 1.day,
        stop_at: Time.current + 3.days)
    end

    it 'returns only actual announcements' do
      expect(described_class.actual).to eq([actual_announcement])
    end
  end

  describe '.exclude_read' do
    let!(:read_announcement_one) { create(:announcement, content: 'read announcement one initial content') }
    let!(:read_announcement_two) { create(:announcement, content: 'read announcement two initial content') }
    let!(:unread_announcement) { create(:announcement) }
    
    context 'read announcements have not been updated' do
      it 'returns only unread announcement' do
        read_announcements = {
          read_announcement_one.id.to_s => read_announcement_one.content_digest,
          read_announcement_two.id.to_s => read_announcement_two.content_digest }
        expect(described_class.exclude_read(read_announcements)).to eq([unread_announcement])
      end
    end

    context 'unread announcement has same digest as read one' do
      before { unread_announcement.update_attributes(content_digest: read_announcement_one.content_digest) }

      it 'returns unread announcement anyway' do
        read_announcements = {
          read_announcement_one.id.to_s => read_announcement_one.content_digest,
          read_announcement_two.id.to_s => read_announcement_two.content_digest }
        expect(described_class.exclude_read(read_announcements)).to eq([unread_announcement])
      end
    end

    context 'one of read announcements was updated' do
      let!(:read_announcement_one_initial_digest) { read_announcement_one.content_digest }
      before { read_announcement_one.update_attributes(content: 'read announcement one updated content') }

      subject do
        read_announcements = {
          read_announcement_one.id.to_s => read_announcement_one_initial_digest,
          read_announcement_two.id.to_s => read_announcement_two.content_digest }
        described_class.exclude_read(read_announcements).order(id: :asc)
      end

      it 'returns unread announcement and updated read announcement' do
        expect(subject).to eq([read_announcement_one, unread_announcement])
      end
    end

    context 'both read announcements were updated' do
      let!(:read_announcement_one_initial_digest) { read_announcement_one.content_digest }
      let!(:read_announcement_two_initial_digest) { read_announcement_two.content_digest }
      before do
        read_announcement_one.update_attributes(content: 'read announcement one updated content')
        read_announcement_two.update_attributes(content: 'read announcement two updated content')
      end

      subject do
        read_announcements = {
          read_announcement_one.id.to_s => read_announcement_one_initial_digest,
          read_announcement_two.id.to_s => read_announcement_two_initial_digest }
        described_class.exclude_read(read_announcements).order(id: :asc)
      end

      it 'returns unread announcement and updated read announcement' do
        expect(subject).to eq([read_announcement_one, read_announcement_two, unread_announcement])
      end
    end
  end

  describe '.latest_stop_at' do
    let!(:announcement_with_earliest_stop_time) { create(:announcement) }
    let!(:announcement_with_middle_stop_time) do
      create(:announcement, stop_at: Time.current + 5.days)
    end
    let!(:announcement_with_latest_stop_time) do
      create(:announcement, stop_at: Time.current + 7.days)
    end

    it 'returns latest stop_at datetime for give announcement ids' do
      given_ids = [announcement_with_middle_stop_time.id,
                   announcement_with_latest_stop_time.id,
                   announcement_with_earliest_stop_time.id]
      expect(described_class.latest_stop_at(given_ids)).to\
        eq(announcement_with_latest_stop_time.reload.stop_at)
    end
  end
end
