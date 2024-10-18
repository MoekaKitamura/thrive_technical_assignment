class User
  attr_reader :id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens

  def initialize(user_data)
    @id = user_data["id"]
    @first_name = user_data["first_name"]
    @last_name = user_data["last_name"]
    @email = user_data["email"]
    @company_id = user_data["company_id"]
    @email_status = user_data["email_status"]
    @active_status = user_data["active_status"]
    @tokens = user_data["tokens"]

    validate!
  end

  def format_user_info(company_top_up)
    <<~USER_INFO.gsub(/^/, "\t")
      #{last_name}, #{first_name}, #{email}
        Previous Token Balance, #{tokens}
        New Token Balance #{tokens + company_top_up}
    USER_INFO
  end

  private
    def validate!
      raise "id is missing" if id.nil?
      raise "first name is missing" if first_name.nil?
      raise "last name is missing" if last_name.nil?
      raise "email is missing" if email.nil?
      raise "company id is missing" if company_id.nil?
      raise "email status is missing" if email_status.nil?
      raise "active status is missing" if active_status.nil?
      raise "tokens is missing" if tokens.nil?
    end
end
