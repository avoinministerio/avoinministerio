# Ensure the agent is started using Unicorn
# This is needed when using Unicorn and preload_app is not set to true.
# See https://newrelic.com/docs/troubleshooting/im-using-unicorn-and-i-dont-see-any-data
NewRelic::Agent.after_fork(:force_reconnect => true) if defined? Unicorn
