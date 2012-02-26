Factory.define :profile do |p|
  p.first_name 'Erkki'
  p.last_name 'Esimerkki'
end
Factory.define :citizen do |c|
end

Factory.define :erkki, :parent => :citizen do |e|
  e.email 'erkki@esimerkki.fi'
  e.first_name 'Erkki'
  e.last_name 'Esimerkki'
  e.password 'sekretPa$$word'
  e.association :profile, factory: :profile
end

Factory.define :authentication do |a|
  a.provider 'facebook'
  a.uid '1234567'
end
Factory.define :facebookin_erkki, parent: :erkki do |e|
  e.after_create do |erkki|
    Factory.create(:authentication, citizen: erkki)
  end
end
