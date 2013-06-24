require 'spec_helper'

module Boostify
  module Jobs
    describe SyncCharities do
      let(:job) { Boostify::Jobs::SyncCharities }

      before do
        Boostify.favorite_charities = [1, 44]

        Boostify.favorite_charities.each do |charity_id|
          url = "#{Boostify.charity_api_endpoint}/#{charity_id}.json"
          stub_http_request(:get, url).
            to_return status: 200, body: charity_response(charity_id)
        end
      end

      it 'creates charities' do
        expect do
          job.perform
        end.to change(Charity, :count).from(0).to(2)
      end

      it 'sets the boost_id' do
        job.perform
        Charity.pluck(:boost_id).should == [1, 44]
      end

      context 'when downloading fails' do
        before do
          Faraday::Response.any_instance.stub(:success?).and_return(false)
        end

        it 'raises an error' do
          expect do
            job.perform
          end.to raise_error(RuntimeError, /Failed to download Charity/)
        end
      end

      context 'when run again' do
        before { job.perform }

        it 'does not create new charities again' do
          expect do
            job.perform
          end.to_not change(Charity, :count)
        end

        context 'when a charity is changed' do
          let(:charity) { Charity.where(boost_id: 1).first }

          before { charity.update_attributes!(title: 'Title') }

          it 'updates the charity' do
            expect do
              job.perform
              charity.reload
            end.to change(charity, :title).from('Title').to('Charity_1')
          end
        end
      end

      def charity_response(id)
        {
          charity: {
            id: id,
            title: "Charity_#{id}",
            name: "Charity Number #{id} e.V.",
            url: "http://boost-project.com/de/charities/#{id}",
            short_description: 'Awesome Charity',
            description: 'Boost our Awesome Charity',
            logo: 'http://url.to/logo.png',
            advocates: id,
            income: 23.42
          }
        }.to_json
      end
    end
  end
end
