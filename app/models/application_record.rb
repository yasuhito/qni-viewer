# frozen_string_literal: true

# ActiveRecord の共通設定
# TODO: DB を使わなければ消す
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
