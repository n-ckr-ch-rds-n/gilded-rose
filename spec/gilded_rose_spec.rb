require 'gilded_rose.rb'

describe GildedRose do

  before(:each) do
    @smarties = Item.new("Smarties", 5, 20)
    @custard = Item.new("Custard", 0, 10)
    @agedbrie = Item.new("Aged Brie", 10, 30)
    @agedbrie2 = Item.new("Aged Brie", 10, 50)
    @sulfuras = Item.new("Sulfuras, Hand of Ragnaros", 10, 50)
    @backstagepass = Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 10)

    @conjured_item = Item.new("Conjured Bread", 10, 30)

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

  describe '#decrease_item_quality' do
    it 'reduces the quality of non-sulfuras items' do
      @gildedrose.decrease_item_quality(@smarties)
      expect(@smarties.quality).to eq(19)
    end

    it 'does not reduce the quality of sulfuras' do
      @gildedrose.decrease_item_quality(@sulfuras)
      expect(@sulfuras.quality).to eq(50)
    end
  end

  describe '#increase_item_quality' do
    it 'reduces the quality of items whose quality is lower than 50' do
      @gildedrose.increase_item_quality(@agedbrie)
      expect(@agedbrie.quality).to eq(31)
    end
  end

  describe '#decrease_item_sell_in' do
    it 'reduces sell_in of non-sulfuras items' do
      @gildedrose.decrease_item_sell_in(@smarties)
      expect(@smarties.sell_in).to eq(4)
    end

    it 'does not reduce the sell_in of sulfuras' do
      @gildedrose.decrease_item_sell_in(@sulfuras)
      expect(@sulfuras.sell_in).to eq(10)
    end
  end

  describe '#apply_extra_quality_increases_to_backstage_passes' do
    it 'applies an extra quality increase when the concert is 10 days away' do
      5.times { @gildedrose.update_quality }
      @gildedrose.apply_extra_quality_increases_to_backstage_passes(@backstagepass)
      expect(@backstagepass.quality).to eq(16)
    end
  end

  describe '#set_quality_to_zero_for_out_of_date_backstage_passes' do
    it 'backstage pass quality is set to zero when out of date' do
      @gildedrose.set_quality_to_zero_for_out_of_date_backstage_passes(@backstagepass)
      expect(@backstagepass.quality).to eq(0)
    end
  end

  describe '#decrease_quality_for_out_of_date_items' do
    it 'decreases quality if not backstage pass or brie' do
      @gildedrose.decrease_quality_for_out_of_date_items(@smarties)
      expect(@smarties.quality).to eq(19)
    end
  end

  describe '#manage_quality_for_out_of_date_items' do
    it 'decreases quality for out of date normal items' do
      @gildedrose.update_quality
      @gildedrose.manage_quality_for_out_of_date_items(@custard)
      expect(@custard.quality).to eq(7)
    end

    it 'increases quality for out of date brie' do
      10.times { @gildedrose.update_quality }
      @gildedrose.manage_quality_for_out_of_date_items(@agedbrie)
      expect(@agedbrie.quality).to eq(40)
    end
  end

  describe '#decrease_quality_of_normal_and_conjured_items' do

    it 'decreases the quality of normal items' do
      @gildedrose.decrease_quality_of_normal_and_conjured_items(@smarties)
      expect(@smarties.quality).to eq(19)
    end

    it 'does not decrease the quality of aged brie' do
      @gildedrose.decrease_quality_of_normal_and_conjured_items(@agedbrie)
      expect(@agedbrie.quality).to eq(30)
    end

  end

  describe '#increase_quality_of_special_items' do

    it 'increases the quality of aged brie and backstage passes' do
      @gildedrose.increase_quality_of_special_items(@agedbrie)
      expect(@agedbrie.quality).to eq(31)
    end

    it 'does not increase the quality of smarties' do
      @gildedrose.increase_quality_of_special_items(@smarties)
      expect(@smarties.quality).to eq(20)
    end

  end

  describe '#increase_quality_for_passes_ten_days_before_concert' do
    it 'increases quality for backstage passes ten days before a concert' do
      5.times { @gildedrose.update_quality }
      @gildedrose.increase_quality_for_passes_ten_days_before_concert(@backstagepass)
      expect(@backstagepass.quality).to eq(16)
    end
  end

  describe '#increase_quality_for_passes_five_days_before_concert' do
    it 'increases quality for backstage passes ten days before a concert' do
      10.times { @gildedrose.update_quality }
      @gildedrose.increase_quality_for_passes_five_days_before_concert(@backstagepass)
      expect(@backstagepass.quality).to eq(26)
    end
  end

  describe '#decrease_quality_if_not_aged_brie' do
    it 'decreases quality for out of date items if not brie' do
      @gildedrose.decrease_quality_if_not_aged_brie(@smarties)
      expect(@smarties.quality).to eq(19)
    end
  end

  describe '#increase_quality_for_aged_brie' do
    it 'increases the quality of aged brie' do
      @gildedrose.increase_quality_for_aged_brie(@agedbrie)
      expect(@agedbrie.quality).to eq(31)
    end
  end

  describe '#decrease_quality_for_conjured_items' do
    it 'decreases quality if an item is conjured' do
      @gildedrose.decrease_quality_for_conjured_items(@conjured_item)
      expect(@conjured_item.quality).to eq(29)
    end
  end

end
