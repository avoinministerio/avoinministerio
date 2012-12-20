namespace :kansalaisaloite do

  desc 'Fetch ideas from index page and paginate over'
  task :fetch_index => :environment do
    header
    k = Kansalaisaloite.new
    k.max_pages = 50
    k.max_pages = eval("#{ENV['MAX_PAGES']}") || k.max_pages
    k.fetch_index
    footer("Max. pages: #{k.max_pages}", k)
  end

  desc 'Fetch ideas within given range of ids, eg. IDS_RANGE=1..20'
  task :fetch_range => :environment do
    header
    k = Kansalaisaloite.new
    k.ids_range = 1..50
    k.ids_range = eval("#{ENV['IDS_RANGE']}") || k.ids_range
    k.fetch_range
    footer("Ids range: #{k.ids_range}", k)
  end

  namespace :cron do
    desc 'Set cron with whenever. Setup in config/schedule.rb'
    task :enable do
      `whenever --update-crontab kansalaisaloite --set environment=#{ENV['RAILS_ENV']}`
    end

    desc 'Disable cron'
    task :disable do
      `whenever --clear-crontab kansalaisaloite --set environment=#{ENV['RAILS_ENV']}`
    end
  end

  def header
    I18n.locale = :en
    puts "="*100
    @start_time = Time.zone.now
    puts "STARTED #{I18n.localize(Time.now, format: :short)}"
  end

  def footer(msg, instance)
    puts "-"*100
    puts "#{msg}, Total fetched: #{instance.total_fetched}"
    puts "Finished at #{I18n.localize(Time.now, format: :short)}, #{minutes_ago}"
    puts "="*100
    puts
  end

  def minutes_ago
    minutes = (@start_time - Time.zone.now)/60
    (minutes < 1 ? 'less 1 minute' : "#{minutes} minutes") + ' ago'
  end
end
