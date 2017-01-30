import Foundation

class GarageDefaults {

    static let sharedInstance = GarageDefaults()

    private let defaults = UserDefaults(suiteName: "group.me.overacker.garage")!

    private struct Keys {
        static let Host = "host"
        static let Pin = "pin"
    }

    private init() {
        host = defaults.string(forKey: Keys.Host)
        pin = defaults.integer(forKey: Keys.Pin)
    }

    var host: String? {
        didSet {
            defaults.set(host, forKey: Keys.Host)
        }
    }

    var pin: Int? {
        didSet {
            defaults.set(pin, forKey: Keys.Pin)
        }
    }

}
