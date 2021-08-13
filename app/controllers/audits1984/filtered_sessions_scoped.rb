module Audits1984
  module FilteredSessionsScoped
    extend ActiveSupport::Concern

    included do
      before_action :set_filtered_sessions
    end

    private
      def set_filtered_sessions
        @filtered_sessions = Audits1984::FilteredSessions.resume(session[:filtered_sessions])
      end
  end
end
