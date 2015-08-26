FactoryGirl.define do
  factory :announcement, class: Readit::Announcement do
    sequence(:content) { |n| "AnnouncementContent#{n}" }
    is_active true
    start_at Time.current
    stop_at Time.current + 3.days
  end
end
