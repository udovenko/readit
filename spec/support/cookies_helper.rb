module CookiesHelper
  # Extracts content of read announcements cookie into hash. Returns empty
  # hash if cookie is not set.
  #
  # *Returns*:
  # {Hash} Read announcement ids
  def extract_read_announcements
    JSON.parse(cookies[:readit_announcements])
  end

  # Writes given announcement data hash to cookie string.
  #
  # *Arguments*:
  # - +read_announcements+ {Array} Read announcements hash
  def store_read_announcements(read_announcements)
    cookies[:readit_announcements] = {
      value: read_announcements.to_json,
      expires: Readit::Announcement.latest_stop_at(read_announcements.keys) + 1.day
    }
  end
end
