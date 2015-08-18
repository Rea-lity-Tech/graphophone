# -*- coding: utf-8 -*-

require 'jruby_art'
require 'jruby_art/app'

Processing::App::SKETCH_PATH = __FILE__

Processing::App.load_library :graphophone, :PapARt, :javacv, :toxiclibscore

module Graphophone
  include_package 'fr.inria.graphophone'
  include_package 'fr.inria.graphophone.attributes.image'
  include_package 'fr.inria.graphophone.attributes.position'
  include_package 'fr.inria.graphophone.attributes.sound'
end

module Papartlib
  include_package 'fr.inria.papart.procam'
  include_package 'fr.inria.papart.procam.camera'
end


require_relative 'basic_cursor'
require_relative 'note_player'
require_relative 'ar_cursor'


class MyApp < Processing::App
  
  def settings
    fullScreen P3D
  end 

  def setup

    @cursors = []
    
    @papart = Papartlib::Papart.projection self
    @papart.loadTouchInput()
    @app1 = PaperApp.new
    @papart.startTracking
  end

  def draw
    
  end

end




class PaperApp < Papartlib::PaperTouchScreen
  
  def setup
    setDrawingSize(297, 210);
    loadMarkerBoard(Papartlib::Papart::markerFolder + "A3-small1.cfg", 297, 210);

    @capture_size = Processing::PVector.new(210, 210)
    @origin = Processing::PVector.new(0, 0)
    @pic_size = 512
    
    @board_view = Papartlib::TrackedView.new self
    @board_view.setCaptureSizeMM(@capture_size)
    
    @board_view.setImageWidthPx(@pic_size)
    @board_view.setImageHeightPx(@pic_size)
    
    @board_view.setBottomLeftCorner(@origin)
    
    @board_view.init

    @cursors = []
    
  end
  
  def draw

    beginDraw2D
    background 0
    noFill
    stroke 100
    rect @origin.x, @origin.y, @capture_size.x, @capture_size.y

    @current_image = @board_view.getViewOf(cameraTracking)
    
    if @current_image != nil

      @current_image.loadPixels
      image(@current_image, 210, 0, 50, 50)
      drawTouch 8
      
      touchList.get2DTouchs.each do |touch|
#        puts touch.speed.mag 

        next if touch.touchPoint.isYoung $app.millis
        
        if touch.speed.mag > 10
          create_cursor touch
        end
      end

      scale reality_ratio

      @cursors.each do |cursor|
          cursor.setImage @current_image
          cursor.update $app.millis
          cursor.drawSelf getGraphics
        end
        
        @cursors.delete_if { |cursor|  not cursor.active }

    end
    endDraw
  end
  
  def reality_ratio ; @capture_size.x / @pic_size ; end
  def image_ratio ; @pic_size / @capture_size.x ; end
  
  def create_cursor touch
    return if  @current_image == nil
    return if touch.touchPoint.attachedValue != -1

    cursor_size = image_ratio * (20 +  (Random.rand * 30).to_i)

    p_x = touch.position.x * image_ratio
    p_y = touch.position.y * image_ratio
    s_x = touch.speed.x * image_ratio / 20.0
    s_y = touch.speed.y * image_ratio / 20.0
    
    cursor = ARCursor.new(Processing::PVector.new(p_x, p_y),
                             Processing::PVector.new(s_x, s_y),
                             cursor_size)
    cursor.setImage  @current_image
    touch.touchPoint.attachedValue = 1
    touch.touchPoint.attachedObject = cursor
    @cursors << cursor 
  end
  
end



MyApp.new unless defined? $app
