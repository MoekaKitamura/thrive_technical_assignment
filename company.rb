class Company
  attr_reader :id, :name, :top_up, :email_status

  def initialize(data)
    @id = data["id"]
    @name = data["name"]
    @top_up = data["top_up"]
    @email_status = data["email_status"]

    validate!
  end

  def build_company_report(sorted_users)
    emailed_users_list = []
    not_emailed_users_list = []

    sorted_users.each do |user|
      user_info = user.format_user_info(top_up)

      if user.email_status == true && user.email_status == email_status
        emailed_users_list << user_info
      else
        not_emailed_users_list << user_info
      end
    end

    <<~COMPANY_REPORT.gsub(/^/, "\t")
      Company Id: #{id}
      Company Name: #{name}
      Users Emailed:#{emailed_users_list.any? ? "\n\t" : ''}#{emailed_users_list.join.strip}
      Users Not Emailed:#{not_emailed_users_list.any? ? "\n\t" : ''}#{not_emailed_users_list.join.strip}
      Total amount of top ups for #{name}: #{sorted_users.count * top_up}
    COMPANY_REPORT
  end

  private
    def validate!
      raise "id is missing" if id.nil?
      raise "name is missing" if name.nil?
      raise "top up amount must be a positive number" unless top_up.is_a?(Numeric) && top_up >= 0
      raise "email status is missing" if email_status.nil?
    end
end
