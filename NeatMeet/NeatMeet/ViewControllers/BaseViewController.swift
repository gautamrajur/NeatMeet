import UIKit

class BaseViewController: UIViewController {
    
    private var connectivityAlertController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNetworkMonitoring()
    }
    
    private func setupNetworkMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleConnectivityChange), name: .connectivityStatusChanged, object: nil)
        checkConnectivity()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleConnectivityChange() {
        checkConnectivity()
    }
    
    private func checkConnectivity() {
        if NetworkMonitor.shared.isConnected {
            dismissNoInternetAlert()
        } else {
            showNoInternetAlert()
        }
    }
    
    private func showNoInternetAlert() {
        if connectivityAlertController == nil {
            connectivityAlertController = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and restart app.", preferredStyle: .alert)
            DispatchQueue.main.async {
                self.present(self.connectivityAlertController!, animated: true, completion: nil)
            }
        }
    }
    
    private func dismissNoInternetAlert() {
        if let alertController = connectivityAlertController {
            alertController.dismiss(animated: true, completion: nil)
            connectivityAlertController = nil
        }
    }
}
