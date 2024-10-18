require "json"
require "./company"
require "./user"

class CompanyProcessor
  OUTPUT_TEXT_FILE = "output.txt".freeze
  COMPANIES_JSON_FILE = "companies.json".freeze
  USERS_JSON_FILE = "users.json".freeze

  def initialize
    @companies = load_json(COMPANIES_JSON_FILE).map { |data| Company.new(data) }
    @users = load_json(USERS_JSON_FILE).map { |data| User.new(data) }
  end

  def process
    output_text = []

    companies.each do |company|
      active_users = users.select { |user| user.company_id == company.id && user.active_status }

      next if active_users.empty?

      sorted_users = active_users.sort_by(&:last_name)
      output_text << company.build_company_report(sorted_users)
    end

    save_output_to_file(output_text.join("\n"))
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

    def save_output_to_file(output_text)
      File.open(OUTPUT_TEXT_FILE, "w") do |file|
        file.puts output_text
      end
    end
end

company_processor = CompanyProcessor.new
company_processor.process
