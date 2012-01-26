require 'redmine'
Dir::foreach(File.join(File.dirname(__FILE__), 'lib')) do |file|
  next unless /\.rb$/ =~ file
  require file
end

Redmine::Plugin.register :redmine_bioproj do
  name 'BIOPROJ plugin'
  author 'Arnaud Martel'
  description 'Fonctionnalités additionnelles pour BIOPROJ'
  version '0.0.2'
  requires_redmine :version_or_higher => '1.3.0'
  
  project_module :bioproj do
    permission :bioproj_members, {:bioproj_members => [:show, :edit_membership, :destroy_membership, :access]}
  end

end