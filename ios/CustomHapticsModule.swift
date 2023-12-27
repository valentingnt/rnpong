import UIKit
import CoreHaptics

@objc(CustomHapticsModule)
class CustomHapticsModule: NSObject {
  private var engine: CHHapticEngine?
  private var continuousPlayer: CHHapticAdvancedPatternPlayer?
  
  override init() {
    super.init()
    
    if CHHapticEngine.capabilitiesForHardware().supportsHaptics {
      do {
        self.engine = try CHHapticEngine()
        try self.engine?.start()
      } catch let error {
        print("There was an error creating the haptic engine: \(error)")
      }
    }
  }
  
  @objc
  static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  @objc(CustomHapticsFunction:y:)
  func CustomHapticsFunction(x: Float, y: Float) -> Void {
    guard let engine = self.engine else {
        print("Haptic engine not available")
        return
    }
    
    // Normalize coordinates to a [0, 1] spectrum.
    let eventIntensity: Float = 1 - y
    let eventSharpness: Float = x
    
    // Create an intensity parameter:
    let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: eventIntensity)
    
    // Create a sharpness parameter:
    let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: eventSharpness)
    
    // Create a continuous event with a long duration from the parameters.
    let continuousEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 100)
    
    do {
        // Create a pattern from the continuous haptic event.
        let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
        
        // Create a player from the continuous haptic pattern.
        continuousPlayer = try engine.makeAdvancedPlayer(with: pattern)
        
        // Start the player
        try continuousPlayer?.start(atTime: 0)
        
    } catch let error {
        print("Pattern Player Creation Error: \(error)")
    }
  }
}