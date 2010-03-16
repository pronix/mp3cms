class UserSession < Authlogic::Session::Base
  validate :validate_ban
  def validate_ban
    if attempted_record && attempted_record.ban?
      errors.add("ban",[I18n.t("user_ban"),
                        I18n.t('ban_reason', :ban_reason => attempted_record.ban_reason),
                        I18n.t("unblocked_ban", :end_ban => attempted_record.end_ban.to_s(:short) )
                       ].join)
    end

  end
end
