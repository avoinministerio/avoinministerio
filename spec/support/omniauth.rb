def auth_hash
  {
    :provider => 'facebook',
    :uid => '1234567',
    :info => {
      :nickname => 'eerkki',
      :email => 'erkki@esimerkki.fi',
      :name => 'Erkki Esimerkki',
      :first_name => 'Erkki',
      :last_name => 'Esimerkki',
      :image => 'http://graph.facebook.com/1234567/picture?type=square',
      :urls => { :Facebook => 'http://www.facebook.com/eerkki' },
      :location => 'Helsinki, Finland'
    },
    :credentials => {
      :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
      :expires_at => 1321747205, # when the access token expires (if it expires)
      :expires => true # if you request `offline_access` this will be false
    },
    :extra => {
      :raw_info => {
        :id => '1234567',
        :name => 'Erkki Esimerkki',
        :first_name => 'Erkki',
        :last_name => 'Esimerkki',
        :link => 'http://www.facebook.com/eerkki',
        :username => 'eerkki',
        :location => { :id => '123456789', :name => 'Helsinki, Finland' },
        :gender => 'male',
        :email => 'erkki@esimerkki.fi',
        :timezone => 2,
        :locale => 'fi_FI',
        :verified => true,
        :updated_time => '2012-03-01T09:00:00+0200'
      }
    }
  }
end
