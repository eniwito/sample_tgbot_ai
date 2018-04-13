require 'telegram/bot'
require 'api-ai-ruby'

bot_token = 'TELEGRAM_BOT_TOKEN'

ai_client = ApiAiRuby::Client.new(
  client_access_token: 'DIALOGFLOW_ACCESS_TOKEN',
  api_lang: 'ru',
  api_session_id: 'Example'
)
Telegram::Bot::Client.run(bot_token, logger: Logger.new($stderr)) do |bot|
  bot.logger.info('Bot has been started')
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.sendMessage(chat_id: message.chat.id, text: "Yo, #{message.from.first_name}")
    when String
      response = ai_client.text_request message.text
      response = response[:result][:fulfillment][:speech]
      if response.empty?
        bot.api.send_message(chat_id: message.chat.id, text: "I do not understand you")
      else
        bot.api.send_message(chat_id: message.chat.id, text: response)
      end
    end
  end
end