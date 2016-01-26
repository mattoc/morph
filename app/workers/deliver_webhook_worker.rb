class DeliverWebhookWorker
  include Sidekiq::Worker
  sidekiq_options backtrace: true

  def perform(webhook_delivery_id)
    webhook_delivery = WebhookDelivery.find(webhook_delivery_id)
    res = Faraday.post(webhook_delivery.webhook.url)
    webhook_delivery.update_attributes(
      response_code: res.status,
      sent_at: DateTime.now
    )
  end
end
