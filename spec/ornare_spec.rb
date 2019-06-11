require 'ostruct'

RSpec.describe F1SalesCustom::Email::Parser do

  context 'when email is from website' do

    context 'when is contains "vendas" and a state' do

      let(:email) do
        email = OpenStruct.new
        email.to = [email: 'websiteform@lojateste.f1sales.org']
        email.subject = 'vendas: Mensagem de Carolina Martins'
        email.body = "De: Carolina Martins\nE-mail: carolmmgo@hotmail.com\nTelefone: 11 98376 0878\nEstado: SP\n\nOlá Equipe Ornare,\n\nEstou tentando um contato na loja mais próxima da minha casa, mas parece\nque os telefones abaixo não funcionam:\n\nSão Paulo – Gabriel Monteiro da Silva\nAl. Gabriel Monteiro da Silva, 1101 – Jd. Paulistano\n2ª a 6ª das 10h às 20h e sáb. das 10h às 14h\nTel.: +55 (11) 3065.6622\nAssistência Técnica: +55 (11) 3090.3250\n\nAntes de enviar o orçamento, eu gostaria de conversar com alguém da loja\nlocalizada no Jd. Paulistano.\n\nObrigada,\nCarolina Martins"

        email
      end

      let(:parsed_email) { described_class.new(email).parse }

      it 'contains website form as source name' do
        expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all.first[:name])
      end

      it 'contains name' do
        expect(parsed_email[:customer][:name]).to eq('Carolina Martins')
      end

      it 'contains email' do
        expect(parsed_email[:customer][:email]).to eq('carolmmgo@hotmail.com')
      end

      it 'contains phone' do
        expect(parsed_email[:customer][:phone]).to eq('11983760878')
      end

      it 'contains product' do
        expect(parsed_email[:product]).to eq('Vendas')
      end

      it 'contains a message' do
        expect(parsed_email[:message]).to eq("\nOlá Equipe Ornare,\n\nEstou tentando um contato na loja mais próxima da minha casa, mas parece\nque os telefones abaixo não funcionam:\n\nSão Paulo – Gabriel Monteiro da Silva\nAl. Gabriel Monteiro da Silva, 1101 – Jd. Paulistano\n2ª a 6ª das 10h às 20h e sáb. das 10h às 14h\nTel.: +55 (11) 3065.6622\nAssistência Técnica: +55 (11) 3090.3250\n\nAntes de enviar o orçamento, eu gostaria de conversar com alguém da loja\nlocalizada no Jd. Paulistano.\n\nObrigada,\nCarolina Martins")
      end
    end

  end
end


