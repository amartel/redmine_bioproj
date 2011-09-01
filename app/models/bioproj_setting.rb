class BioprojSetting < ActiveRecord::Base
  belongs_to :project

  def self.find_or_create(pj_id)
    setting = BioprojSetting.find(:first, :conditions => ['project_id = ?', pj_id])
    unless setting
      setting = BioprojSetting.new
      setting.project_id = pj_id
      setting.non_member_role_id = 0
      setting.anonymous_role_id = 0
      setting.save!      
    end
    return setting
  end
end
