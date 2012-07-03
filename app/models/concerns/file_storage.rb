module Concerns::FileStorage
  extend ActiveSupport::Concern

  module ClassMethods
    # REVIEW: Refactor to use redis or other temporal storage for saving file urls - jaakko

    def store_file(file_name, content, expires_at = 10.minutes.from_now)
      fog_upload(file_name, content, expires_at)
    end

    def get_file(file_name, expires_at = 10.minutes.from_now)
      fog_url(file_name, expires_at) if fog_file_exists?(file_name)
    end

    def delete_file(file_name)
      fog_destroy(file_name)
    end

    private

    def fog_connection
      # REVIEW: When changing Cloud provider, refactor here ;) - jaakkos
      @@_fog_connection ||= ::Fog::Storage.new(
        provider: 'AWS',
        aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      )
    end

    def fog_directory_name
      raise NotImplementedError.new("You are using FileStorage concern, so you must implement self.fog_directory_name.")
    end

    def fog_directory
      fog_connection.directories.get(self.fog_directory_name) || fog_connection.directories.create(:key => self.fog_directory_name, :public => false)
    end

    def fog_upload(file_name, content, expires_at = 10.minutes.from_now)
      fog_directory.files.create(
        key: file_name,
        body: content,
        public: false,
        expires: expires_at
      )
    end

    def fog_download(file_name)
      fog_directory.files.get(file_name)
    end

    def fog_destroy(file_name)
      fog_file_exists?(file_name).try(:destroy)
    end

    def fog_url(file_name, expires_at = 5.minutes.from_now)
      fog_download(file_name).url(expires_at)
    end

    def fog_file_exists?(file_name)
      fog_directory.files.head(file_name)
    end
  end
end