require "json"

class CompanyProcessor
  OUTPUT_TEXT_FILE = "output.txt".freeze
  COMPANIES_JSON_FILE = "companies.json".freeze
  USERS_JSON_FILE = "users.json".freeze

  def initialize
    @companies = load_json(COMPANIES_JSON_FILE)
    @users = load_json(USERS_JSON_FILE)
  end

  def process
    output_text = []

    companies.each do |company|
      active_users = users.select { |user| user["company_id"] == company["id"] && user["active_status"] }

      next if active_users.empty?

      sorted_users = active_users.sort_by { |user| user["last_name"] }
      output_text << build_company_report(company, sorted_users)
    end

    save_output_to_file(output_text)
  end

  private
    attr_reader :companies, :users

    def load_json(file_name)
      JSON.parse(File.read(file_name))
    rescue Errno::ENOENT
      puts "Error: File not found - #{file_name}"
      []
    rescue JSON::ParserError
      puts "Error: Could not parse JSON from file - #{file_name}"
      []
    end

    def build_company_report(company, sorted_users)
      emailed_users_list = []
      not_emailed_users_list = []

      sorted_users.each do |user|
        user_info = format_user_info(user, company["top_up"])

        if user["email_status"] == true && user["email_status"] == company["email_status"]
          emailed_users_list << user_info
        else
          not_emailed_users_list << user_info
        end
      end

      <<~COMPANY_REPORT.gsub(/^/, "\t")
        Company Id: #{company["id"]}
        Company Name: #{company["name"]}
        Users Emailed:
          #{emailed_users_list.join.strip}
        Users Not Emailed:
          #{not_emailed_users_list.join.strip}
        Total amount of top ups for #{company["name"]}: #{sorted_users.count * company["top_up"]}

      COMPANY_REPORT
    end

    def format_user_info(user, company_top_up)
      <<~USER_INFO.gsub(/^/, "\t")
        #{user["last_name"]}, #{user["first_name"]}, #{user["email"]}
          Previous Token Balance, #{user["tokens"]}
          New Token Balance #{user["tokens"] + company_top_up}
      USER_INFO
    end

    def save_output_to_file(output_text)
      File.open(OUTPUT_TEXT_FILE, "w") do |file|
        file.puts output_text
      end
    end
end

company_processor = CompanyProcessor.new
company_processor.process
