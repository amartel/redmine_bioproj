module BioprojApplicationControllerPatch
  def self.included(base) # :nodoc:
    base.send(:include, UserMethodsBioprojApplicationController)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      alias_method_chain :find_current_user, :bioproj
    end
  end
end

module UserMethodsBioprojApplicationController
  def find_current_user_with_bioproj
    user = find_current_user_without_bioproj
    if user && user.admin && !Setting.plugin_redmine_bioproj['bioproj_ip'].empty?
      if request && request.remote_ip 
        if request.remote_ip.match(/#{Setting.plugin_redmine_bioproj['bioproj_ip']}/).nil?
          Rails.logger.error "Administrator access denied (ip: #{request.remote_ip})"
          user = nil
        end
      end
    end
    user.update_column(:last_login_on, Time.now) if user && !user.new_record?
    user
  end
end

ApplicationController.send(:include, BioprojApplicationControllerPatch)
