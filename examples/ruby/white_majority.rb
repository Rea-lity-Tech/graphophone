
class WhiteMajority < Graphophone::ImageAttribute


  def initialize
    @white_major = false
  end

  def is_white_major? ; @white_major ; end 

  
  def computeAt position_attribute
    @pos = position_attribute.getPos
    @size = position_attribute.getSize
    compute_is_white_major
  end

  
  def compute_is_white_major
    
    return if @size == 0
    
    start_x = Processing::App.constrain(@pos.x - @size, 0, currentImage.width)
    end_x = Processing::App.constrain(@pos.x + @size, 0, currentImage.width)
    start_y = Processing::App.constrain(@pos.y - @size, 0, currentImage.height)
    end_y = Processing::App.constrain(@pos.y + @size, 0, currentImage.height)
    
    nb_white = 0
    others = 0
    
    (start_x...end_x).each do |x|
      (start_y...end_y).each do |y|
        
        offset = y * currentImage.width + x

        b = brightness currentImage.pixels[offset]
        if b > 220
          nb_white = nb_white + 1
        else
          others = others + 1
        end
      end
    end
    
    @white_major = nb_white > others
  end

  def brightness c 
     red = c >> 16 & 0xFF
     green = c >> 8 & 0xFF
     blue = c & 0xFF
     (red + green + blue) / 3.0
  end

  def getValues ; [] ; end
  
end
