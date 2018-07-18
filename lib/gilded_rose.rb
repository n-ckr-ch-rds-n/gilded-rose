class GildedRose

  attr_reader :items

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      unless name_is?("Aged Brie", item) || name_is?("Backstage passes to a TAFKAL80ETC concert", item)
        if quality_is_greater_than?(0, item)
          decrease_quality(item) unless name_is?("Sulfuras, Hand of Ragnaros", item)
        end
      else
        if quality_is_less_than?(50, item)
          increase_quality(item)
          if name_is?("Backstage passes to a TAFKAL80ETC concert", item)
            if item.sell_in < 11
              increase_quality(item) if quality_is_less_than?(50, item)
            end
            if item.sell_in < 6
              increase_quality(item) if quality_is_less_than?(50, item)
            end
          end
        end
      end
      unless name_is?("Sulfuras, Hand of Ragnaros", item)
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        unless name_is?("Aged Brie", item)
          unless name_is?("Backstage passes to a TAFKAL80ETC concert", item)
            if quality_is_greater_than?(0, item)
              decrease_quality(item) unless name_is?("Sulfuras, Hand of Ragnaros", item)
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          increase_quality(item) if item.quality < 50
        end
      end
    end
  end

  def increase_quality(item)
      item.quality += 1
  end

  def decrease_quality(item)
      item.quality -= 1
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
