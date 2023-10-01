//
//  ReadyComponents.swift
//  ExportApps
//
//  Created by Levent ÖZGÜR on 19.09.2023.
//

import Cocoa
import CryptoSwift

final class ReadyComponents {
    public static var shared = ReadyComponents()
}

extension ReadyComponents {
    func createTitle(title: String, size: Int? = 14, addToStackView: NSStackView) {
        let tmpTitle = NSTextField()
        tmpTitle.translatesAutoresizingMaskIntoConstraints = false
        tmpTitle.stringValue = title
        tmpTitle.font = NSFont.boldSystemFont(ofSize: 14)
        tmpTitle.isEditable = false
        tmpTitle.isBezeled = false
        tmpTitle.drawsBackground = false
            
        addToStackView.addArrangedSubview(tmpTitle)
    }
    
    func createTextField(title: String? = nil, placeHolder: String? = "", addToStackView: NSStackView) {
        let tmpStackview = NSStackView()
        tmpStackview.translatesAutoresizingMaskIntoConstraints = false
        tmpStackview.orientation = .horizontal
        tmpStackview.alignment = .centerY
        tmpStackview.spacing = 10.0
        
        addToStackView.addArrangedSubview(tmpStackview)


        if let title {
            let tmpTitle = NSTextField()
            tmpTitle.translatesAutoresizingMaskIntoConstraints = false
            tmpTitle.stringValue = title
            tmpTitle.font = NSFont.boldSystemFont(ofSize: 14)
            tmpTitle.isEditable = false
            tmpTitle.isBezeled = false
            tmpTitle.drawsBackground = false
            tmpStackview.addArrangedSubview(tmpTitle)
        }

        let tmpTextField = EditableNSTextField()
        tmpTextField.translatesAutoresizingMaskIntoConstraints = false
        tmpTextField.placeholderString = placeHolder
        tmpTextField.font = NSFont.systemFont(ofSize: 14)
        tmpTextField.isEditable = true
        tmpTextField.drawsBackground = false
        tmpStackview.addArrangedSubview(tmpTextField)
    }
}


//MARK: - Alert
extension ReadyComponents {
    func showAlert(title: String, text: String? = nil) {
        let alert = NSAlert()
        alert.messageText = title
        if let text = text {
            alert.informativeText = text
        }
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Tamam")
        alert.runModal()
    }
    
    func showUserCredentialAlert() {
        var user: UserCredential? = nil
        
        switch KeyChainHepler.shared.getUserCredentials() {
        case .success(let credentials):
            let jsonData = Data(credentials.utf8)
            guard let userCredentials = try? JSONDecoder().decode(UserCredential.self, from: jsonData) else { break }
            user = userCredentials
            break
        case .failure(let err):
            ReadyComponents.shared.showAlert(title: err.localizedDescription)
            break
        }

        let emailField = EditableNSTextField()
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.placeholderString = "Email"
        emailField.stringValue = user?.email ?? ""
        emailField.font = NSFont.systemFont(ofSize: 14)
        emailField.isEditable = true
        emailField.drawsBackground = false

        let passwordField = EditableNSTextField()
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.placeholderString = "Password"
        passwordField.font = NSFont.systemFont(ofSize: 14)
        passwordField.isEditable = true
        passwordField.drawsBackground = false

        let stackView = NSStackView()
        stackView.setFrameSize(NSSize(width: 300, height: 60))
        stackView.translatesAutoresizingMaskIntoConstraints = true
        stackView.orientation = .vertical

        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)

        let alert = NSAlert()
        alert.messageText = "User Credentials"
        alert.informativeText = "Sistem üzerinde tanımlanan Eposta ve Şifre bilginizi girin."
        alert.accessoryView = stackView
        alert.addButton(withTitle: "Tamam")
        alert.addButton(withTitle: "İptal")
        let modalResult = alert.runModal()

        switch(modalResult) {
        case .alertFirstButtonReturn:
            let email = emailField.stringValue
            let password = passwordField.stringValue
            guard email != "",  password != "" else { ReadyComponents.shared.showAlert(title: "Credential Alanları Boş Olamaz!"); return }
            //Save to keychain
            
            let userCredentials = UserCredential(email: email, password: password.sha1())
            let jsonEncoder = JSONEncoder()
            guard let jsonData = try? jsonEncoder.encode(userCredentials),
                  let json = String(data: jsonData, encoding: String.Encoding.utf8) else { return }
            
            switch( user != nil ? KeyChainHepler.shared.updateUserCredentials(newData: json) : KeyChainHepler.shared.saveUserCredentials(data: json)) {
            case .success():
                ReadyComponents.shared.showAlert(title: "Bilgileriniz Başarılı bir şekilde \(user != nil ? "değiştirildi." : "kaydedildi.") ")
                break
            case .failure(let error):
                print(error)
                ReadyComponents.shared.showAlert(title: "Beklenmedik Bir Hata Oluştu! \(error)")
                break
            }
        default:
            break
        }
    }
}
