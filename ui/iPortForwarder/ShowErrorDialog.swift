import AppKit

import Libipf

func showErrorDialog(_ error: Error) {
    let alert = NSAlert()
    alert.messageText = "Error"
    switch error {
    case let ipfError as IpfError:
        alert.informativeText = "\(ipfError.message())."
    default:
        alert.informativeText = error.localizedDescription
    }
    alert.alertStyle = NSAlert.Style.critical
    alert.addButton(withTitle: "OK")
    alert.runModal()
}
