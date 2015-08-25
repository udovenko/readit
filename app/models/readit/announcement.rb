# Implements site announcement model.
#
# Author:: Denis Udovenko (mailto:denis.e.udovenko@gmail.com)
module Readit
  class Announcement < ActiveRecord::Base
    validates :content, presence: true
    validates :start_at, presence: true
    validates :stop_at, presence: true
    validate :start_and_stop_datetime_order

    before_save :calculate_content_digest

    scope :active, proc { where(is_active: true) }
    scope :actual, proc { where(':time_now BETWEEN start_at AND stop_at', time_now: Time.current) }
    scope :exclude_read, proc { |read_announcements|
      current_scope = all

      read_announcements.each do |id, digest|
        current_scope = current_scope.where('NOT (id = :id AND content_digest = :content_digest)',
          id: id, content_digest: digest)
      end

      current_scope
    }

    # Finds latest stop time for given announcement ids enumeration.
    #
    # *Arguments*:
    # - +ids+ {Array} Announcement ids
    # *Returns*:
    # {Datetime} Latest stop time
    def self.latest_stop_at(ids)
      where(id: ids).maximum(:stop_at).localtime
    end

    private

    # Checks that start_at datetime is less than stop_at.
    #
    # *Returns*:
    # {FlaseClass, TrueClass} False if start_at greater or equal to stop_at
    def start_and_stop_datetime_order
      return true if start_at < stop_at

      errors.add(:base, :start_time_grater_or_equal_to_end_time)
      false
    end

    # Calculates content digest.
    def calculate_content_digest
      self.content_digest = Digest::MD5.hexdigest(content)
    end
  end
end
