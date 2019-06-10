require "ornare/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"

module Ornare
  
  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'websiteform',
          name: 'Vendas - SP'
        }
      ]
    end 
  end

  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash
      state = parsed_email['estado'].split("\n").first
      message = @email.body.split('Estado').last.split("\n").drop(1).join("\n")
      department = @email.subject.split(':').first
      source = F1SalesCustom::Email::Source.all.select { |source| source[:name] == "#{department.capitalize} - #{state.upcase}" }.first
      source_name = source[:name]

      {
        source: {
          name: source_name, 
        },
        customer: {
          name: parsed_email['de'],
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: '',
        message: message,
      }
    end

  end
end

#TODO Move this to common helper
class String
  def colons_to_hash(split_exp = /(\n[A-Z].*?:)/, insert_line_break = true)
    insert(0, "\n") if insert_line_break
    gsub!('*', '')
    data = split(split_exp).drop(1)
    is_key = true
    key = ''
    result = {}
    data.each do |content|
      if is_key
        key = content.downcase.gsub(/[^0-9a-z ]/i, '')
        key.gsub!(' ', '_')
        result[key] = '' if result[key].nil? or result[key] == ''
      else
        result[key] = content.strip if result[key] == ''
      end

      is_key = !is_key
    end

    result
  end 
end
