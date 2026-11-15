// Writes the current Wi-Fi SSID to ~/.cache/sketchybar/ssid.
// macOS only reveals the SSID to an app that has Location permission, so this runs as a tiny app bundle.
import CoreLocation
import CoreWLAN
import Foundation

final class Helper: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    func start() {
        manager.delegate = self
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            finish()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus != .notDetermined { finish() }
    }

    func finish() {
        let ssid = CWWiFiClient.shared().interface()?.ssid() ?? ""
        let dir = NSHomeDirectory() + "/.cache/sketchybar"
        try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true)
        try? ssid.write(toFile: dir + "/ssid", atomically: true, encoding: .utf8)
        exit(0)
    }
}

let helper = Helper()
helper.start()
DispatchQueue.main.asyncAfter(deadline: .now() + 15) { exit(1) }
RunLoop.main.run()
