import UIKit
import WebIOPi

class GarageViewController: UIViewController {

    @IBOutlet weak var doorButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var pi: WebIOPi?
    var latestConfiguration: GPIOConfiguration?

    override func viewDidAppear(_ animated: Bool) {
        if let host = GarageDefaults.sharedInstance.host {
            let oldTitle = doorButton.titleLabel?.text

            doorButton.setTitle("", for: .normal)
            doorButton.isEnabled = false
            activityIndicator.startAnimating()

            let pi = WebIOPi(host: host)
            pi.GPIO.getConfiguration(completion: { (status, config) in
                self.activityIndicator.stopAnimating()
                self.doorButton.isEnabled = true
                self.doorButton.setTitle(oldTitle, for: .normal)

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
            })
        } else {
            performSegue(withIdentifier: "Settings", sender: self)
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

        guard let pin = GarageDefaults.sharedInstance.pin else {
            let alert = UIAlertController(
                title: "Uh oh!",
                message: "GPIO pin not configured. Please add one in settins.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "Settings", sender: self)
            }))

            self.present(alert, animated: true, completion: nil)
            return
        }

        guard let doorPin = config.GPIOPins[pin] else {
            return
        }

        guard let function = doorPin.function, function == .out else {
            doorPin.changeFunction(to: .out) { status in
                self.doorButtonPressed()
            }
            return
        }

        doorPin.runSequence([.on, .off, .on], delay: 10) { status in
            if status != .ok {
                let alert = UIAlertController(
                    title: "Uh oh!",
                    message: "Something went wrong. Status: \(status)",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
