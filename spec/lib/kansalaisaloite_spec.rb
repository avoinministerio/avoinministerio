require 'spec_helper'

describe Kansalaisaloite do

  let(:external_resource) { Kansalaisaloite.new }
  use_vcr_cassette "initiatives/all", :record => :once

  before :each do
    FactoryGirl.create(:author_kansalaisaloite)
  end

  describe '#page' do
    it 'should return array' do
      external_resource.fetch_index
      external_resource.page.should be_a Array
    end
  end

  describe '#max_pages' do
    it 'should set maximum pages' do
      external_resource.max_pages = 1
      external_resource.max_pages.should be 1
    end

    it 'should set current page' do
      external_resource.max_pages = 1
      external_resource.fetch_index
      external_resource.current_page.should be 1
    end
  end

  describe '#fetch_index' do
    before :each do
      external_resource.max_pages = 2
    end

    it 'should save new initiative' do
      stub_initiatives_index_request
      lambda { external_resource.fetch_index }.should change(Idea, :count).by(2)
    end

    it 'should only save new initiatives' do
      resource_1 = stub_200_initiative_detail_request(1)
      stub_initiatives_index_request
      external_resource.max_pages = 1
      FactoryGirl.create(:idea, :additional_collecting_service_urls => resource_1.id)

      lambda { external_resource.fetch_index }.should change(Idea, :count).by(1)
    end

  end

  describe '#fetch_range' do
    use_vcr_cassette "initiatives/details", :record => :once
    before :each do
      external_resource.ids_range = 1..3
      external_resource.max_attempts = 4
    end

    it 'should save initiative detail' do
      stub_404_initiative_detail_request(1)
      stub_200_initiative_detail_request(2)
      stub_200_initiative_detail_request(3)
      lambda { external_resource.fetch_range }.should change(Idea, :count).by(2)
    end

    it 'should continue fetching on few 404 requests' do
      external_resource.ids_range = 1..6
      external_resource.max_attempts = 4
      stub_404_initiative_detail_request(1)
      stub_404_initiative_detail_request(2)
      stub_404_initiative_detail_request(3)
      stub_200_initiative_detail_request(4)
      stub_404_initiative_detail_request(5)
      stub_200_initiative_detail_request(6)
      lambda { external_resource.fetch_range }.should change(Idea, :count).by(2)
    end

    it 'should stop fetching on maximum attempts' do
      external_resource.ids_range = 1..5
      external_resource.max_attempts = 2
      stub_404_initiative_detail_request(1)
      stub_200_initiative_detail_request(2)
      stub_404_initiative_detail_request(3)
      stub_404_initiative_detail_request(4)
      stub_404_initiative_detail_request(5)
      expect { external_resource.fetch_range }.to raise_error(Kansalaisaloite::Maximum404Requests)
    end
  end

  describe 'rake task kansalaisaloite:fetch_range' do
    require 'rake'
    load File.join(Rails.root, 'Rakefile')

    it 'should save initiative detail' do
      stub_200_initiative_detail_request(1)
      stub_200_initiative_detail_request(2)
      stub_200_initiative_detail_request(3)
      ENV['IDS_RANGE'] = '1..3'

      expect { Rake::Task['kansalaisaloite:fetch_range'].invoke }.to change(Idea, :count).by(3)
    end

    it 'should fetch index page' do
      ENV['MAX_PAGES'] = '1'
      stub_initiatives_index_request
      expect { Rake::Task['kansalaisaloite:fetch_index'].invoke }.to change(Idea, :count).by(2)
    end
  end

  describe 'Idea' do
    use_vcr_cassette "initiatives/details", :record => :once, :allow_playback_repeats =>  true

    before :each do
      external_resource.ids_range = 1..5
    end

    describe '#additional_service_data' do
      it 'should keep count history' do
        2.times { external_resource.fetch_range }
        Idea.last.additional_service_data[:counts].size.should be(2)
      end
    end


  end

  #https://www.kansalaisaloite.fi/api/v1/initiatives?offset=0&limit=5
  def stub_initiatives_index_request
    resource_1 = stub_200_initiative_detail_request(1)
    resource_2 = stub_200_initiative_detail_request(2)
    initiatives_array = [{id: resource_1.id, name: resource_1.name}, {id: resource_2.id, name: resource_2.name}].to_json
    stub_request(:get, /offset/).to_return(body: initiatives_array)
  end

  def stub_404_initiative_detail_request(id)
    stub_request(:get, /www.kansalaisaloite.fi\/api\/v1\/initiatives\/#{id}/).to_return(body: '', status: 404)
  end

  def stub_200_initiative_detail_request(id)
    initiative_detail = OpenStruct.new(stub_initiative_hash(id))
    stub_request(:get, /www.kansalaisaloite.fi\/api\/v1\/initiatives\/#{id}/).
        to_return(body: initiative_detail.marshal_dump.to_json)
    initiative_detail
  end

  def stub_initiative_hash(id)
    {id: "http://www.kansalaisaloite.fi/api/v1/initiatives/#{id}",
     name: {fi: 'Proposal name'},
     proposal: {fi: 'Proposal description'},
     supportCount: rand(500)
    }
  end

end