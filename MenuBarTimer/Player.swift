import AppKit

final class SoundPlayer {
	
	func play(volume: Double) {
		guard volume > 0 else { return }
		guard let sound = NSSound(named: "Glass") else { return }
		sound.volume = Float(volume)
		sound.play()
	}
}
