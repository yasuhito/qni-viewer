# frozen_string_literal: true

# メール送信の共通設定
# TODO: 使わないので消す
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
