class BioprojController < ApplicationController
  unloadable
  layout 'base'

  before_filter :find_project
  before_filter :find_current_user, :find_project_repository, :only => [ :export_committers ]
  accept_api_auth :export_committers

  def show
  end

  def export_committers
    if User.current.allowed_to?(:manage_repository, @project)
      respond_to do |format|
        format.csv  { send_data(commiters_to_csv(@repository), :type => 'text/csv; header=present', :filename => 'export.csv') }
        format.xml  { send_data(commiters_to_xml(@repository), :type => 'text/xml', :filename => 'export.xml') }
      end
    else
      render(:nothing => true)
    end
  end

  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @project = Project.find(params[:id])
  end

  def find_project_repository
    if params[:repository_id].present?
      @repository = @project.repositories.find_by_identifier_param(params[:repository_id])
    else
      @repository = @project.repository
    end
    (render_404; return false) unless @repository
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def commiters_to_csv(repository)
    decimal_separator = l(:general_csv_decimal_separator)
    encoding = l(:general_csv_encoding)
    columns = [ "committer_name", "firstname", "lastname", "mail" ]

    export = FCSV.generate(:col_sep => l(:general_csv_separator)) do |csv|
      # csv header fields
      csv << columns.collect {|c| Redmine::CodesetUtil.from_utf8(c.to_s, encoding) }

      # csv lines
      committers = @repository.committers
      committers.each do |committer, user_id|
        user = repository.find_committer_user(committer)
        col_values = [ committer, user.nil? ? "" : user.firstname, user.nil? ? "" : user.lastname, user.nil? ? "" : user.mail ]
        csv << col_values.collect {|c| Redmine::CodesetUtil.from_utf8(c.to_s, encoding) }
      end

    end
    export
  end

  def commiters_to_xml(repository)
    repository.to_xml :skip_types => true, :only => [ :project_id, :identifier ] do |xml|
      xml.commiters do
        committers = repository.committers
        committers.each do |committer, user_id|
          user = repository.find_committer_user(committer)
          xml.committer do
            xml.committer_name committer
            xml.firstname user.nil? ? "" : user.firstname
            xml.lastname user.nil? ? "" : user.lastname
            xml.mail user.nil? ? "" : user.mail
          end
        end
      end
    end
  end

end
