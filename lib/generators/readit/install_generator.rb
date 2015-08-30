module Readit
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc 'Copies migrations and mounts routes for your application'

      def self.next_migration_number(_path)
        if @prev_migration_nr
          @prev_migration_nr += 1
        else
          @prev_migration_nr = Time.now.utc.strftime('%Y%m%d%H%M%S').to_i
        end
        @prev_migration_nr.to_s
      end

      # Copies migration templates to application migration files.
      def copy_migrations
        migration_template 'create_readit_announcements.rb', 'db/migrate/create_readit_announcements.rb'
      end

      # Injects routes into application routes file.
      def mount_routes
        route "mount Readit::Engine => '/readit'"
      end
    end
  end
end
