# Implements controller for announcements interactions.
#
# Author:: Denis Udovenko (mailto:denis.e.udovenko@gmail.com)
module Readit
  class AnnouncementsController < ApplicationController
    include Announcements::Cookie

    # Stores given announcement id in cookie. Removes not actual announcement ids from
    # cookie if necessary. Updated cookie expiration time.
    def store_reviewed
      read_announcements = extract_read_announcements
      update_read_announcements(read_announcements)
      store_read_announcement(read_announcements)

      redirect_to :back
    end

    private

    # Removes deleted announcements data from read announcements hash and adds just read
    # announcement content digest.
    #
    # *Arguments*
    # - +read_announcements+ {Hash} Extracted read announcements
    def update_read_announcements(read_announcements)
      existing_announcements = Announcement.where(id: read_announcements.keys)
      existing_announcement_ids = existing_announcements.map { |announcement| announcement.id.to_s }
      read_announcements.delete_if { |key, _| !existing_announcement_ids.include?(key) }
      read_announcements[params[:id].to_i] = announcement_params[:content_digest]
    end

    # Writes given announcement data hash to cookie string.
    #
    # *Arguments*:
    # - +read_announcements+ {Hash} Read announcements hash
    def store_read_announcement(read_announcements)
      cookies[:readit_announcements] = {
        value: read_announcements.to_json,
        expires: Announcement.latest_stop_at(read_announcements.keys) + 1.day }
    end

    # Permits announcement parameters from received parameters hash.
    #
    # *Returns*
    # {Hash} Announcement permitted parameters
    def announcement_params
      params.require(:announcement).permit(:content_digest)
    end
  end
end
