import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!

    override func viewWillAppear(_ animated: Bool) {
        if let host = GarageDefaults.sharedInstance.host {
            hostTextField.text = host
        }

        if let pin = GarageDefaults.sharedInstance.pin {
            pinTextField.text = "\(pin)"
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let host = hostTextField.text, host.characters.count > 0 {
            GarageDefaults.sharedInstance.host = host
        }

        if let pin = pinTextField.text, pin.characters.count > 0 {
            GarageDefaults.sharedInstance.pin = Int(pin)
        }
    }

}
