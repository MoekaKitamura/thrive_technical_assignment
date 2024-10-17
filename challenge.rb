require "json"

OUTPUT_TEXT_FILE = "output.txt".freeze
COMPANIES_JSON_FILE = "companies.json".freeze
USERS_JSON_FILE = "users.json".freeze

def load_json(file_name)
  JSON.parse(File.read(file_name))
end

def process_companies(companies, users)
  output_text = []

  companies.each do |company|
    active_users = users.select { |user| user["company_id"] == company["id"] && user["active_status"] }

    next if active_users.empty?

    sorted_users = active_users.sort_by { |user| user["last_name"] }
    output_text << build_company_report(company, sorted_users)
  end

  output_text
end

def build_company_report(company, users)
  emailed_users_info = []
  not_emailed_users_info = []

  users.each do |user|
    user_info = format_user_info(user, company["top_up"])

    if user["email_status"] == true && user["email_status"] == company["email_status"]
      emailed_users_info << user_info
    else
      not_emailed_users_info << user_info
    end
  end

  <<~COMPANY_REPORT.gsub(/^/, "\t")
    Company Id: #{company["id"]}
    Company Name: #{company["name"]}
    Users Emailed:
      #{emailed_users_info.join.strip}
    Users Not Emailed:
      #{not_emailed_users_info.join.strip}
    Total amount of top ups for #{company["name"]}: #{users.count * company["top_up"]}

  COMPANY_REPORT
end

def format_user_info(user, company_top_up)
  new_token_balance = user["tokens"] + company_top_up

  <<~USER_INFO.gsub(/^/, "\t")
    #{user["last_name"]}, #{user["first_name"]}, #{user["email"]}
      Previous Token Balance, #{user["tokens"]}
      New Token Balance #{new_token_balance}
  USER_INFO
end

def write_output_file(output_text)
  File.open(OUTPUT_TEXT_FILE, "w") do |file|
    file.puts output_text
  end
end

companies = load_json(COMPANIES_JSON_FILE)
users = load_json(USERS_JSON_FILE)

output_text = process_companies(companies, users)

write_output_file(output_text)
