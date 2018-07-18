require 'gilded_rose.rb'

describe GildedRose do

  before(:each) do
    @smarties = Item.new("Smarties", 5, 20)
    @custard = Item.new("Custard", 0, 10)
    @agedbrie = Item.new("Aged Brie", 10, 30)
    @agedbrie2 = Item.new("Aged Brie", 10, 50)
    @sulfuras = Item.new("Sulfuras, Hand of Ragnaros", 10, 50)
    @backstagepass = Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 10)

    @gildedrose = GildedRose.new([@smarties, @custard, @agedbrie, @agedbrie2, @sulfuras, @backstagepass])
  end

  describe '#update_quality' do

    it 'decreases the quality of smarties' do
      @gildedrose.update_quality
      expect(@gildedrose.items[0].quality).to eq(19)
    end

    it 'decreases the sell-in value of smarties' do
      @gildedrose.update_quality
      expect(@gildedrose.items[0].sell_in).to eq(4)
    end

    it 'after sell by date quality decreases twice as fast' do
      @gildedrose.update_quality
      expect(@gildedrose.items[1].quality).to eq(8)
    end

    it 'aged brie increases in quality with each update' do
      @gildedrose.update_quality
      expect(@gildedrose.items[2].quality).to eq(31)
    end

    it 'items cannot have a quality of more than 50' do
      @gildedrose.update_quality
      expect(@gildedrose.items[3].quality).to eq(50)
    end

    it 'sulfuras does not decrease in quality and never has to be sold' do
      @gildedrose.update_quality
      expect(@gildedrose.items[4].quality).to eq(50)
      expect(@gildedrose.items[4].sell_in).to eq(10)
    end

    it 'backstage pass increases in quality as sell_in value decreases' do
      @gildedrose.update_quality
      expect(@gildedrose.items[5].quality).to eq(11)
    end

    it 'backstage pass quality increases at twice the speed when 10 days left' do
      5.times { @gildedrose.update_quality }
      @gildedrose.update_quality
      expect(@gildedrose.items[5].quality).to eq(17)
    end

    it 'backstage pass quality increases at three times the speed when 5 days left' do
      10.times { @gildedrose.update_quality }
      @gildedrose.update_quality
      expect(@gildedrose.items[5].quality).to eq(28)
    end

    it 'backstage pass quality decreases to 0 after concert' do
      15.times { @gildedrose.update_quality }
      @gildedrose.update_quality
      expect(@gildedrose.items[5].quality).to eq(0)
    end

  end

  describe '#increase_quality_by' do
    it 'increases quality by given number' do
      @gildedrose.increase_quality_by(1, @smarties)
      expect(@smarties.quality).to eq(21)
    end
  end

  describe '#decrease_quality_by' do
    it 'decreases quality by given number' do
      @gildedrose.decrease_quality_by(1, @smarties)
      expect(@smarties.quality).to eq(19)
    end
  end

  describe '#decrease_sell_in_by' do
    it 'decreases sell_in by given number' do
      @gildedrose.decrease_sell_in_by(1, @smarties)
      expect(@smarties.sell_in).to eq(4)
    end
  end

  describe '#name_is?' do
    it 'checks item name' do
      expect(@gildedrose.name_is?("Smarties", @smarties)).to eq true
    end
  end

  describe '#quality_is_greater_than?' do
    it 'checks if quality is above a given threshold' do
      expect(@gildedrose.quality_is_greater_than?(5, @smarties)).to eq true
    end
  end

  describe '#quality_is_less_than?' do
    it 'checks if quality is less than a given threshold' do
      expect(@gildedrose.quality_is_less_than?(5, @smarties)).to eq false
    end
  end

  describe '#sell_in_is_less_than?' do
    it 'checks if sell_in is less than a given threshold' do
      expect(@gildedrose.sell_in_is_less_than?(5, @smarties)).to eq false
    end
  end

end
