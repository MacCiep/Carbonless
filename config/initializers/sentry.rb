# Sentry.init do |config|
#   config.dsn = 'https://bafc0ce99862450f96dae07d1dccc0eb@o4505078923001856.ingest.sentry.io/4505078940303360'
#   config.breadcrumbs_logger = [:active_support_logger, :http_logger]
#
#   # Set traces_sample_rate to 1.0 to capture 100%
#   # of transactions for performance monitoring.
#   # We recommend adjusting this value in production.
#   config.traces_sample_rate = 1.0
#   # or
#   config.traces_sampler = lambda do |context|
#     true
#   end
# end