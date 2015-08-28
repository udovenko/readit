require 'spec_helper'

feature 'Announcements' do
  let!(:announcement_one) { create(:announcement) }
  let!(:announcement_two) { create(:announcement) }

  before { visit root_path }

  it 'shows both announcements' do
    expect(all(Selectors::ANNOUNCEMENT_SELECTOR)[0]).to have_content announcement_one.content
    expect(all(Selectors::ANNOUNCEMENT_SELECTOR)[1]).to have_content announcement_two.content
  end

  context 'user confirmed that he read first announcement' do
    before do
      first(Selectors::ANNOUNCEMENT_READ_SUBMIT_BUTTON_SELECTOR).click
    end

    it('is a root page') { expect(current_path).to eq root_path }

    it 'shows only one announcement' do
      expect(all(Selectors::ANNOUNCEMENT_SELECTOR).count).to eq 1
    end

    it 'shows second announcement' do
      expect(find(Selectors::ANNOUNCEMENT_SELECTOR)).to have_content announcement_two.content
    end

    context 'user confirmed that he read second announcement' do
      before do
        find(Selectors::ANNOUNCEMENT_READ_SUBMIT_BUTTON_SELECTOR).click
      end

      it('is a root page') { expect(current_path).to eq root_path }

      it 'shows no announcements' do
        expect(page).not_to have_selector(Selectors::ANNOUNCEMENT_SELECTOR)
      end
    end
  end
end
