require_dependency "audits1984/application_controller"

module Audits1984
  class AuditsController < ApplicationController
    include FilteredSessionsScoped

    before_action :set_session
    before_action :set_audit, only: %i[ update ]

    def create
      @audit = @session.audits.create!(audit_param.merge(auditor: Current.auditor))
      redirect_to_next_session
    end

    def update
      @audit.update!(audit_param)
      redirect_to_next_session
    end

    private
      def set_session
        @session = Console1984::Session.find(params[:session_id])
      end

      def set_audit
        @audit = @session.audits.find(params[:id])
      end

      def audit_param
        params.require(:audit).permit(:notes, :status)
      end

      def redirect_to_next_session
        next_path = if next_session = @filtered_sessions.pending_session_after(@session)
          next_session
        else
          sessions_path
        end

        redirect_to next_path, notice: "Session #{@session.id} was #{@audit.status}"
      end
  end
end
