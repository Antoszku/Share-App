//
//  ShareViewController.swift
//  Share-Extension
//
//  Created by Dominik Rygiel on 01/04/2019.
//  Copyright © 2019 Dominik Rygiel. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    private let urlScheme = "ourShareAppUrlScheme"
    private let userDefaults = UserDefaults(suiteName: "group.DominikRygiel.share")

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        view.isHidden = true
    }

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
            let attachment = item.attachments?.first else { return }

        attachment.loadDataRepresentation(forTypeIdentifier: String(kUTTypeImage)) { [weak self] data, error in
            guard let data = data,
                let _ = UIImage(data: data) else {
                    print("Couldn't load file")
                    return
            }

            var images = self?.userDefaults?.array(forKey: "SharedImages") ?? []
            images.append(data)
            self?.userDefaults?.set(images, forKey: "SharedImages")

            self?.openApplication()
            self?.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    override func configurationItems() -> [Any]! {
        didSelectPost()
        return []
    }
    
    @objc private func keyboardWillShow() {
        view.endEditing(true)
    }

    private func openApplication() {
        let url = URL(string: urlScheme + "://")!
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")

        while (responder != nil) {
            if (responder?.responds(to: selectorOpenURL)) == true {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder?.next
        }
    }
}
