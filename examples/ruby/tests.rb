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

    @secondIm = createImage(width, height, RGB) if @secondIm == nil
    
    img = @camera.getPImageCopyTo(@secondIm)

    return if img == nil

    @current_image = img
    image(@current_image, 0, 0, width, height)
    
    @cursors.each do |cursor|
      cursor.setImage @current_image
      cursor.update millis
      cursor.drawSelf self.g
    end
    
    @cursors.delete_if { |cursor|  not cursor.active }
    
  end
  
  def mouseReleased (*args)
    createCursor
  end
  
  def createCursor
    return if  @current_image == nil
    cursor_size = 5 + random(15)
    cursor = BasicCursor.new(Processing::PVector.new(mouse_x, mouse_y), 
                             Processing::PVector.new(pmouse_x - mouse_x, pmouse_y - mouse_y), 
                             cursor_size)

    cursor.setImage  @current_image
    @cursors << cursor 
  end


  
end



MyApp.new unless defined? $app
