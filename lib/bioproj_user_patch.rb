module BioprojUserPatch
  def self.included(base) # :nodoc:
    base.send(:include, UserMethodsBioproj)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development

      alias_method_chain :roles_for_project, :bioproj
    end
  end
end

module UserMethodsBioproj
  def roles_for_project_with_bioproj(project)
    roles = roles_for_project_without_bioproj(project)
    @role_non_member ||= Role.non_member
    @role_anonymous ||= Role.anonymous

    if roles[0] == @role_anonymous
      setting = BioprojSetting.find_or_create project
      if setting.anonymous_role_id > 1
        roles = []
        roles << Role.find(setting.anonymous_role_id - 2)
      elsif setting.anonymous_role_id == 1
        roles = []
      end
    elsif roles[0] == @role_non_member
      setting = BioprojSetting.find_or_create project
      if setting.non_member_role_id > 1
        roles = []
        roles << Role.find(setting.non_member_role_id - 2)
      elsif setting.non_member_role_id == 1
        roles = []
      end
    end
    roles
  end
end

User.send(:include, BioprojUserPatch)
