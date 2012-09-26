# Wiki Extensions plugin for Redmine
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

class BioprojMembersController < ApplicationController
  unloadable
  layout 'base'

  before_filter :find_project, :authorize, :find_user
  def show
    if @theuser
      redirect_to :controller => 'projects', :action => "settings", :id => @project, :tab => 'members2', :user_id => @theuser
    else
      redirect_to :controller => 'projects', :action => "settings", :id => @project, :tab => 'members2'
    end
  end

  def edit_membership
    project = nil
    if params[:membership_id]
      @membership = Member.find(params[:membership_id])
      project = @membership.project
      if project.nil? || !User.current.allowed_to?(:manage_members, project)
        render_403
        return false
      else
        @membership = Member.edit_membership(params[:membership_id], params[:membership], @theuser)
        @membership.save if request.post?
      end
    else
      if params[:membership] && params[:membership_project_id]
        params[:membership_project_id].each do |pid|
          project = nil
          project = Project.find(pid)
          if project.nil? || !User.current.allowed_to?(:manage_members, project)
            render_403
            return false
          else
            params[:membership][:project_id] = pid
            @membership = Member.edit_membership(params[:membership_id], params[:membership], @theuser)
            @membership.save if request.post?
          end
        end
      end
    end
    if @membership.valid?
      respond_to do |format|
        format.html { redirect_to :controller => 'projects', :action => "settings", :id => @project, :tab => 'members2', :user_id => @theuser  }
        format.js
        format.api {
          render_api_ok
        }
      end
    else
      respond_to do |format|
        format.js {
          render(:update) {|page|
            page.alert(l(:notice_failed_to_save_members, :errors => @membership.errors.full_messages.join(', ')))
          }
        }
      end
    end

  end

  def destroy_membership
    @membership = Member.find(params[:membership_id])
    if !User.current.allowed_to?(:manage_members, @membership.project)
      @membership=nil
      render_403
      return false
    else
      if request.delete? && @membership.deletable?
        @membership.destroy
      end
      respond_to do |format|
        format.html { redirect_to :controller => 'projects', :action => "settings", :id => @project, :tab => 'members2', :user_id => @theuser }
        format.js { render(:update) {|page| page.replace_html "tab-content-members2", :partial => 'bioproj_members/show'} }
      end
    end
  end

  def access
    setting = BioprojSetting.find_or_create @project.id
    begin
      setting.transaction do
        setting.anonymous_role_id = params[:anon_role_id].to_i
        setting.non_member_role_id = params[:non_member_role_id].to_i
        setting.save!
      end
      flash[:notice] = l(:notice_successful_update)
    rescue
      flash[:error] = "Updating failed."
    end

    if @theuser
      redirect_to :controller => 'projects', :action => "settings", :id => @project, :tab => 'members2', :user_id => @theuser
    else
      redirect_to :controller => 'projects', :action => "settings", :id => @project, :tab => 'members2'
    end
  end
  
  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:id])
  end

  def find_user
    @user = User.current
    @theuser = nil
    if params[:user_id] && !params[:user_id].start_with?("--")
      if params[:user_id] == 'current'
        require_login || return
        @theuser = User.current
      else
        @theuser = User.find(params[:user_id])
      end
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
