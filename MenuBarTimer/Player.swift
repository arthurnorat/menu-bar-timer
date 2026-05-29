import AppKit
import SwiftUI

final class SoundPlayer {
    @AppStorage("dingVolume") private var dingVolume: Double = 0.5

    func play() {
        guard dingVolume > 0 else { return }
        guard let sound = NSSound(named: "Glass") else { return }
        sound.volume = Float(dingVolume)
        sound.play()
    }
}
