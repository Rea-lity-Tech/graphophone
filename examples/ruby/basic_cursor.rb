
class BasicCursor

  attr_reader :active  
  @@lastCursorID = 0  

  def initialize(pos, speed, size)

    @id = @@lastCursorID;
    @@lastCursorID = @@lastCursorID +1

    @active = true;
    @is_ready = false
    @image = nil
    @bounds = nil 

    initPositionAttributes(pos, speed, size)
    initImageAttributes
    initSoundAttributes
  end
  
  def initPositionAttributes(pos, speed, size)
    @position_attributes = []
    @position_std = Graphophone::PositionStandard.new(pos, speed, size)
    
    @position_attributes << @position_std
  end
  
  def initImageAttributes
    @image_attributes = []
    @gauss = Graphophone::GaussianDerivative.new
    @image_attributes << @gauss
  end
  
  def initSoundAttributes
    @sound_attributes = []
#    @note_player = Graphophone::NotePlayer.new

    @note_player = NoteAttribute.new

    @sound_attributes << @note_player
  end

  def setImage(image)
    @image = image
    @image_attributes.each {|im| im.setImage @image } 
    @bounds = Graphophone::Rectangle.createFrom @image if @bounds == nil
  end
  
  def setBounds(rectangle)
    @bounds = Graphophone::Rectangle.getCopyOf rectangle
  end
  
  def update (time) 
    return if not ready?
    updatePositionFromImage
    checkForCollisions
    updateImageAttributes
    updateSoundAttributes(time)
    checkValidity
  end

  def ready? ; @image != nil && @bounds != nil ; end
  
  def updatePositionFromImage
    @position_attributes.each do |position|
      @image_attributes.each do |image|
        position.mapFrom image
      end
    end
  end
  
  def checkForCollisions
    
    @position_attributes.each do |position_attribute|
      
      pos = position_attribute.getPos
      speed = position_attribute.getSpeed
      
      if (pos.x < @bounds.minX) 
        pos.x = @bounds.minX
        speed.x = -speed.x
      end
      
      if (pos.x >= @bounds.maxX) 
        pos.x = @bounds.maxX - 1
        speed.x = -speed.x
      end
      
      if (pos.y < @bounds.minY) 
        pos.y = @bounds.minY
        speed.y = -speed.y
      end
      
      if (pos.y >= @bounds.maxY) 
        pos.y = @bounds.maxY - 1
        speed.y = -speed.y
      end
      
    end
  end

  def updateImageAttributes 
    @position_attributes.each do |position|
      @image_attributes.each do |image|
        image.computeAt(position)
      end
    end
  end
  
  def updateSoundAttributes(time)
    @sound_attributes.each do |sound|
      @position_attributes.each do |position|
        @image_attributes.each do |image|
          sound.mapFrom(image, position, time)
        end
      end
    end
  end

  MINUMUM_SPEED = 0.10

  def checkValidity
    @position_attributes.each do |position|
      @active = position.getSpeed().mag() > MINUMUM_SPEED
    end
  end

  def drawSelf(g)
    
    return if not @active
    
    g.pushStyle

    pos = @position_std.getPos
    speed = @position_std.getSpeed
    size = @position_std.getSize
    
    g.fill(255, 100)
    g.stroke(0, 128)
    
    g.ellipse(pos.x, pos.y, size, size)
    g.line(pos.x,
           pos.y,
           pos.x + speed.x * 5,
           pos.y + speed.y * 5)
    
    g.popStyle
  end

end
