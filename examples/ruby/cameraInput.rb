# -*- coding: utf-8 -*-

require 'jruby_art'
require 'jruby_art/app'

Processing::App::SKETCH_PATH = __FILE__

Processing::App.load_library :graphophone, :PapARt, :javacv, :toxiclibscore

module Graphophone
  include_package 'fr.inria.graphophone'
  include_package 'fr.inria.graphophone.cursors'
end

module Papartlib
  include_package 'fr.inria.papart.procam'
  include_package 'fr.inria.papart.procam.camera'
end

class MyApp < Processing::App
  
  def settings
    size(800, 600, P3D)
  end 

  def setup


    @cursors = []

#    @papart = Papartlib::Papart.seeThrough self
#    @papart.loadTouchInput()
#    @app1 = PaperApp.new
#    @papart.startTracking

    @camera = Papartlib::CameraFactory.createCamera(Papartlib::Camera::Type::OPENCV, "0");    
        
    @camera.setParent self
    @camera.setSize 800, 600
    @camera.start
    @camera.setThread


    # fileName = "image.jpg"
    # @current_image = loadImage(sketchPath("") + fileName)

  end

  def draw

    img = @camera.getPImage

    return if img == nil

    @current_image = img
    image(@current_image, 0, 0, width, height)
    
    @cursors.each do |cursor|
      cursor.setImage @current_image
      cursor.update millis
      cursor.drawSelf self.g
    end
    
    @cursors.delete_if { |cursor|  not cursor.isActive }
    
  end
  
  def mouseReleased
    createCursor
  end
  
  
  def createCursor
    return if  @current_image == nil
    cursor_size = 5 + random(15)
    cursor = Graphophone::BasicCursor.new(Processing::PVector.new(mouse_x, mouse_y), 
                                          Processing::PVector.new(pmouse_x - mouse_x, pmouse_y - mouse_y), 
                                          cursor_size)
    cursor.setImage  @current_image
    @cursors << cursor 
  end

end




class PaperApp < Papartlib::PaperScreen
  
  def setup
    setDrawingSize(297, 210);
    loadMarkerBoard(Papartlib::markerFolder + "A3-small1.cfg", 297, 210);

    @captureSize = PVector.new(297, 210)
    @origin = PVector.new(0, 0)
    @picSize = 1024
    
    @board_view = TrackedView.new self
    @board_view.setCaptureSizeMM(captureSize)
    
    @board_view.setImageWidthPx(picSize)
    @board_view.setImageHeightPx(picSize)
    
    @board_view.setBottomLeftCorner(origin)
    
    @board_view.init
    
  end
  
  def draw
    setLocation(0, 0, 0)
    beginDraw2D
    background 40, 200, 200

    $out_image = boardView.getViewOf(cameraTracking)
    image($out_image, 0, 0, @picSize, @picSize) unless $out_image == nil 
    
    endDraw
  end
end



MyApp.new unless defined? $app
