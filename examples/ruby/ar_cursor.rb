require_relative 'position_ar'
require_relative 'white_majority'

class ARCursor

  attr_reader :active  
  @@lastCursorID = 0  

  def initialize(pos, speed, size)

    @id = @@lastCursorID;
    @@lastCursorID = @@lastCursorID +1

    @active = true;
    @is_ready = false
    @image = nil
    @bounds = nil 

    @life_time = 8000 ## in millis
    @start_time = $app.millis
    
    initPositionAttributes(pos, speed, size)
    initImageAttributes
    initSoundAttributes
  end
  
  def initPositionAttributes(pos, speed, size)
    @position_attributes = []
    @position_ar = PositionAR.new(pos, speed, size)
    
    @position_attributes << @position_ar
  end
  
  def initImageAttributes
    @image_attributes = []
    @gauss = Graphophone::GaussianDerivative.new
    @white_major = WhiteMajority.new
    @red_major = Graphophone::RedMajority.new 

    @image_attributes << @gauss
    @image_attributes << @white_major
    @image_attributes << @red_major
  end
  
  def initSoundAttributes
    @sound_attributes = []
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


  def updatePositionFromImage
    
    if @red_major.isRedMajority
      @position_ar.mapFrom @white_major  ## no direction change
      return
    end
    
    @position_attributes.each do |position|
      @image_attributes.each do |image|
        position.mapFrom image
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

    is_timeout = $app.millis - @start_time > @life_time
    @active = false if is_timeout

  end

  def drawSelf(g)
    
    return if not @active
    
    g.pushStyle

    pos = @position_ar.getPos
    speed = @position_ar.getSpeed
    size = @position_ar.getSize

    ## for projection

    g.fill 128, 0, 0
    g.stroke 128
    
    g.fill 255  if @red_major.isRedMajority

    
    g.ellipseMode Processing::App::CENTER
    g.ellipse(pos.x, pos.y, size, size)
    g.line(pos.x,
           pos.y,
           pos.x + speed.x * 5,
           pos.y + speed.y * 5)
    
    g.popStyle
  end

end
