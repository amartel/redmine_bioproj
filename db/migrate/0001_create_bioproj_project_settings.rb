# Webdav plugin for Redmine
# Copyright (C) 2010 Arnaud MARTEL
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
class CreateBioprojProjectSettings < ActiveRecord::Migration
  def self.up
    create_table :bioproj_settings do |t|
      t.column :project_id, :integer
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer
      t.column :non_member_role_id, :integer
      t.column :anonymous_role_id, :integer
    end
  end

  def self.down
    drop_table :bioproj_settings
  end
end
