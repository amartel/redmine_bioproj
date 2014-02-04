require_dependency 'mail_handler'

module ForumMailHandlerPatch
  def self.included(base) # :nodoc:
    base.extend(ForumMailHandlerClassMethods)

    base.send(:include, ForumMailHandlerInstanceMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      alias_method_chain :dispatch, :forums
      class << self
        # I dislike alias method chain, it's not the most readable backtraces

      end

    end

  end

  module ForumMailHandlerClassMethods

  end

  module ForumMailHandlerInstanceMethods
    def dispatch_with_forums
      if m = email.subject.match(/(\[)(.*)(\])/)
        project = Project.find_by_name(m[2].strip)
        if !project.nil?
          board = project.boards.first unless project.nil?
        else
          if m = email.subject.match(/(\[)(.*)( - )(.*)(\])/)
            project = Project.find_by_name(m[2].strip)
            board = project.boards.find_by_name(m[4].strip) unless project.nil?
          end
        end
      end
      
      if !board.nil?
        if email.subject.match(/re: /i)
          dispatch_without_forums
        else
          project = board.project
          # check permission
          raise MailHandler::UnauthorizedAction unless user.allowed_to?(:edit_messages, project)
          message = Message.new(:author => user, :board => board)
          message.subject = email.subject.gsub(/\[[^\]]*\]/,'')
          message.content = plain_text_body
          message.save!
          add_attachments(message)
          logger.info "MailHandler: message ##{message.id} - #{message.subject} created by #{user}" if logger && logger.info
          message
        end
      else
        dispatch_without_forums
      end
    end

    private

  end
end

# Add module to MailHandler
MailHandler.send(:include, ForumMailHandlerPatch)
