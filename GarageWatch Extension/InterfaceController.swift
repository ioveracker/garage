import WatchKit
import Foundation
import WebIOPi

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func doorButtonTapped() {
        let pi = WebIOPi(host: "http://192.168.1.9:8000")
        pi.GPIO.setFunction(.out, pin: 14) { (status) in
            if status == .ok {
                pi.GPIO.runSequence([.on, .off, .on], delay: 10, pin: 14, completion: { (status) in
                    if status != .ok {
                        self.presentAlert(withTitle: "Uh oh!",
                                     message: "Something went wrong. Status: \(status)",
                                     preferredStyle: .alert,
                                     actions: [
                                        WKAlertAction(title: "OK", style: .default, handler: {})])
                    }
                })
            }
        }
    }

}
