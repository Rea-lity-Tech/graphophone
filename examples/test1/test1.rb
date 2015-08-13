# -*- coding: utf-8 -*-

require 'ruby-processing' 
require 'jruby/core_ext'

Processing::Runner 
Dir["#{Processing::RP_CONFIG['PROCESSING_ROOT']}/core/library/\*.jar"].each{ |jar| require jar }
Processing::App::SKETCH_PATH = __FILE__   unless defined? Processing::App::SKETCH_PATH

Processing::App.load_library :graphophone, :PapARt, :javacv, :toxiclibscore

module Graphophone
  include_package 'fr.inria.graphophone'
  include_package 'fr.inria.graphophone.cursors'
end

module Papartlib
  include_package 'fr.inria.papart.procam'
end

class MyApp < Processing::App
  
  def settings
  end 

  def setup

    size(800, 600, P3D)
    @cursors = []

#    @papart = Papartlib::Papart.seeThrough self
#    @papart.loadTouchInput()
#    @app1 = PaperApp.new
#    @papart.startTracking

    camera = CameraFactory.createCamera(Camera.Type.OPENCV, "0");    
        
    camera.setParent self
    camera.setSize 800, 600
    camera.start
    camera.setThread


    # fileName = "image.jpg"
    # @current_image = loadImage(sketchPath("") + fileName)

  end

  def draw

    $out_image = camera.getPImage
    
    if $out_image != nil 
      image($out_image, 0, 0, width, height)
    
      @cursors.each do |cursor|
        cursor.setImage $out_image
        cursor.update millis
        cursor.drawSelf self.g
      end
    
      @cursors.delete_if { |cursor|  not cursor.isActive }
    end
    
  end
  
  def mouseReleased
    createCursor
  end
  
  
  def createCursor
    cursor_size = 5 + random(15)
    cursor = Graphophone::BasicCursor.new(Processing::PVector.new(mouse_x, mouse_y), 
                                          Processing::PVector.new(pmouse_x - mouse_x, pmouse_y - mouse_y), 
                                          cursor_size)
    cursor.setImage @current_image
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
