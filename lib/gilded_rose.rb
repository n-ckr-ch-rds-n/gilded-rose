class GildedRose

  attr_reader :items

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      unless name_is?("Aged Brie", item) || name_is?("Backstage passes to a TAFKAL80ETC concert", item)
        decrease_item_quality(item)
      else
        increase_item_quality(item)
        apply_extra_quality_increases_to_backstage_passes(item)
      end
      decrease_item_sell_in(item)
      if sell_in_is_less_than?(0, item)
        unless name_is?("Aged Brie", item)
          unless name_is?("Backstage passes to a TAFKAL80ETC concert", item)
            decrease_item_quality(item)
          else
            decrease_quality_by(item.quality, item)
          end
        else
          increase_item_quality(item)
        end
      end
    end
  end

  def apply_extra_quality_increases_to_backstage_passes(item)
    if name_is?("Backstage passes to a TAFKAL80ETC concert", item)
      if sell_in_is_less_than?(11, item)
        increase_item_quality(item)
      end
      if sell_in_is_less_than?(6, item)
        increase_item_quality(item)
      end
    end
  end

  def decrease_item_sell_in(item)
    decrease_sell_in_by(1, item) unless name_is?("Sulfuras, Hand of Ragnaros", item)
  end

  def increase_item_quality(item)
    increase_quality_by(1, item) if quality_is_less_than?(50, item)
  end

  def decrease_item_quality(item)
    if quality_is_greater_than?(0, item)
      decrease_quality_by(1, item) unless name_is?("Sulfuras, Hand of Ragnaros", item)
    end
  end

  def increase_quality_by(number, item)
    item.quality += number
  end

  def decrease_quality_by(number, item)
    item.quality -= number
  end

  def decrease_sell_in_by(number, item)
    item.sell_in -= number
  end

  def name_is?(name, item)
    item.name == name
  end

  def quality_is_greater_than?(number, item)
    item.quality > number
  end

  def quality_is_less_than?(number, item)
    item.quality < number
  end

  def sell_in_is_less_than?(number, item)
    item.sell_in < number
  end

end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
