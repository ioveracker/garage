import UIKit
import WebIOPi

class ViewController: UIViewController {

    let pi = WebIOPi(host: "http://192.168.1.9:8000")
    var latestConfiguration: GPIOConfiguration?

    override func viewDidLoad() {
        super.viewDidLoad()
        pi.GPIO.getConfiguration { status, config in
            guard status == .ok else {
                let alert = UIAlertController(
                    title: "Uh oh!",
                    message: "Failed to get configuration for pi. \(status)",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                self.present(alert, animated: true, completion: nil)
                return
            }

            self.latestConfiguration = config
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func doorButtonPressed() {
        guard let config = latestConfiguration else {
            let alert = UIAlertController(
                title: "Uh oh!",
                message: "Pi configuration not found. Try again later.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)
            return
        }

        guard let doorPin = config.GPIOPins[14] else {
            return
        }

        guard let function = doorPin.function, function == .out else {
            doorPin.changeFunction(to: .out) { status in
                self.doorButtonPressed()
            }
            return
        }

        doorPin.runSequence([.on, .off, .on], delay: 10) { status in
        }
    }
}
