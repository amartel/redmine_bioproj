require 'redmine'
Dir::foreach(File.join(File.dirname(__FILE__), 'lib')) do |file|
  next unless /\.rb$/ =~ file
  require file
end

Redmine::Plugin.register :redmine_bioproj do
  name 'BIOPROJ plugin'
  author 'Arnaud Martel'
  description 'Additional features used in our BIOPROJ application'
  version '0.0.4'
  requires_redmine :version_or_higher => '2.0.3'
  
  settings :default => {'bioproj_ip' => '', 'bioproj_logintop' => '', 'bioproj_loginbottom' => ''}, :partial => 'bioproj_settings/settings'

  project_module :bioproj do
    permission :bioproj_members, {:bioproj_members => [:show, :edit_membership, :destroy_membership, :access]}
  end

end