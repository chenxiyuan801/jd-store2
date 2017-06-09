class User < ApplicationRecord
  authenticates_with_sorcery!
  attr_accessor :password, :password_confirmation, :token

  CELLPHONE_RE = /\A(\+86|86)?1\d{10}\z/

  validates_presence_of :password, message: "密码不能为空",
    if: :need_validate_password
  validates_presence_of :password_confirmation, message: "密码确认不能为空",
    if: :need_validate_password
  validates_confirmation_of :password, message: "密码不一致",
    if: :need_validate_password
  validates_length_of :password, message: "密码最短为6位", minimum: 6,
    if: :need_validate_password

  validate :validate_cellphone, on: :create

  private
  def need_validate_password
    self.new_record? ||
      (!self.password.nil? || !self.password_confirmation.nil?)
  end

  def validate_cellphone
      if self.cellphone.nil?
        self.errors.add :base, "手机号不能为空"
        return false
      else
          if !self.cellphone=~ CELLPHONE_RE
            self.errors.add :cellphone, "手机号格式不正确"
            return false
          end

          unless VerifyToken.available.find_by(cellphone: self.cellphone, token: self.token)
            self.errors.add :cellphone, "手机验证码不正确或者已过期"
            return false
          end
        return true
      end
   end

end
