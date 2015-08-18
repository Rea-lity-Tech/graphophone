class PositionAR < Graphophone::PositionStandard

    def updateSpeed

      newSpeed = Processing::PVector.new
      
      if currentAttribute.is_a? Graphophone::GaussianDerivative

        gradient = currentAttribute.getGradient
        
        newSpeed1 = Processing::PVector.new(-gradient.y, gradient.x)
        newSpeed2 = Processing::PVector.new(gradient.y, -gradient.x)
        
        if newSpeed1.dot(speed) > newSpeed2.dot(speed)
          newSpeed = newSpeed1
        else
          newSpeed =  newSpeed2
        end
        
        newMagnitude = newSpeed.mag
        prevMagnitude = speed.mag

        newSpeed.normalize
        self.speed.normalize
        self.speed = slerp(speed, newSpeed, (1.0 - angularInertia))
        self.speed.mult(viscosity * Processing::App.lerp(prevMagnitude,
                                                 newMagnitude,
                                                 (1.0 - magnitudeInertia)));
      end

    end


end
    
