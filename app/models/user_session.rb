class UserSession < Authlogic::Session::Base
  validate :validate_ban
  def validate_ban
    if attempted_record && attempted_record.ban?
      errors.add("ban",attempted_record.ban_reason)
    end

  end
end
