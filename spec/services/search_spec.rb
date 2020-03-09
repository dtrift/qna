require 'rails_helper'

RSpec.describe SearchService do
  context 'calls .find for' do
    let(:query) { 'test query' }

    it 'all resources' do
      expect(ThinkingSphinx).to receive(:search).with(query)

      SearchService.find(query, 'All')
    end

    %w[Question Answer Comment User].each do |resource|
      it "#{resource} model" do
        expect(resource.constantize).to receive(:search).with(query)

        SearchService.find(query, resource)
      end
    end
  end
end
