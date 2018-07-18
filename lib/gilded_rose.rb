class GildedRose

  attr_reader :items

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      unless name_is?(item, "Aged Brie") || name_is?(item, "Backstage passes to a TAFKAL80ETC concert")
        if item.quality > 0
          unless name_is?(item, "Sulfuras, Hand of Ragnaros")
            decrease_quality(item)
          end
        end
      else
        if item.quality < 50
          increase_quality(item)
          if name_is?(item, "Backstage passes to a TAFKAL80ETC concert")
            if item.sell_in < 11
              if item.quality < 50
                increase_quality(item)
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                increase_quality(item)
              end
            end
          end
        end
      end
      unless name_is?(item, "Sulfuras, Hand of Ragnaros")
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        unless name_is?(item, "Aged Brie")
          unless name_is?(item, "Backstage passes to a TAFKAL80ETC concert")
            if item.quality > 0
              unless name_is?(item, "Sulfuras, Hand of Ragnaros")
                decrease_quality(item)
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            increase_quality(item)
          end
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

  def name_is?(item, name)
    item.name == name
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
