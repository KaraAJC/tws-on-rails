require 'spec_helper.rb'

describe City do
  context 'scopes' do
    before(:each) do
      @city = create(:city, :fully_brewed)
      @warm = create(:city, :warming_up)
      @hidden = create(:city, :hidden)
    end

    describe '#default_scope' do
      it 'should include hidden locations' do
        expect(City.all).to include(@city, @warm, @hidden)
      end
    end

    describe '#visible' do
      it 'should not include hidden locations' do
        expect(City.visible).to include(@city, @warm)
        expect(City.visible).not_to include(@hidden)
      end
    end

    describe '#hidden' do
      it 'should only include hidden locations' do
        expect(City.hidden).to include(@hidden)
        expect(City.hidden).not_to include(@city, @warm)
      end
    end
  end
  
  describe '#for_code' do
    it 'should find a city regardless of status' do
      city = create(:city, :hidden, city_code: 'hidden')
      expect(City.for_code('hidden')).to eq(city)
    end
  end

  describe '.proxy_city=' do
    it 'should not be able to save if self is proxy target' do
      city = create(:city)

      city.proxy_cities << city
      expect(city.save).to eq(false)
      expect{ city.save! }.to raise_exception
    end
  end


  describe '.tea_times' do
    before(:each) do
      @second_city = create(:city)
      @third_city = create(:city)
      create_list(:tea_time, 3, city: @second_city)
      create_list(:tea_time, 3, city: @third_city)
      @city = create(:city, proxy_cities: [@second_city, @third_city])
      @tt = create(:tea_time, city: @city)
      @tt_3rd = create(:tea_time, city: @third_city)
    end

    it 'should include tea times associated for that city' do
      expect(@city.tea_times).to include(@tt)
    end

    it 'should include tea times associated for that city AND the proxy cities if specified' do
      expect(@city.tea_times).to include(*@second_city.tea_times, @tt, *@third_city.tea_times)
    end
  end
end
