# Webdav plugin for Redmine
# Copyright (C) 2009  Haruyuki Iida
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

require_dependency 'projects_helper'

module MembersProjectsHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, MembersHelperMethodsWebdav)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      alias_method_chain :project_settings_tabs, :members
    end

  end
end

module MembersHelperMethodsWebdav
  def project_settings_tabs_with_members
    tabs = project_settings_tabs_without_members
    action = {:name => 'members2', :controller => 'bioproj_members', :action => :show, :partial => 'bioproj_members/show', :label => :label_member2_plural}

    tabs << action if (User.current.allowed_to?(:manage_members, @project) && User.current.allowed_to?(:bioproj_members, @project))

    tabs
  end
end

ProjectsHelper.send(:include, MembersProjectsHelperPatch)
