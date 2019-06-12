require "ornare/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_helpers"

module Ornare
  
  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'websiteform',
          name: 'Site - Vendas - SP'
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
      source = F1SalesCustom::Email::Source.all.select { |source| source[:name] == "Site - #{department.capitalize} - #{state.upcase}" }.first
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
        product: department.capitalize,
        message: message,
      }
    end

  end
end
