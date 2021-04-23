//
//  MailView.swift
//  MirSud
//
//  Created by Igor Ivanov on 22.04.2021.
//

import SwiftUI
import UIKit
import MessageUI

struct MailView: UIViewControllerRepresentable {

    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        
        var body: String = ""
        if let defendants = RealmService.loadDefendants() {
            for (idx, d) in defendants.enumerated() {
                
                
                let name = "\(idx+1).    " + d.surname + " " + d.firstName + " " + d.middleName
            
                var vkUsers: String = "VKs: "
                for user in d.vkUsers {
                    vkUsers += "\(user.id)" + "\n"
                }
                
                var cases: String = ""
                for cc in d.civilCases {
                    cases += "дело: " + cc.caseID +
                        "\n дата создания: " + cc.createdDate +
                        "\n участок: " + cc.courtNumber +
                        "\n участок site id: " + cc.courtSiteID +
                        "\n район: " + cc.districtName +
                        "\n дата принятия к производству: " + cc.acceptedDate +
                        "\n описание:  " + cc.description +
                        "\n судья: " + cc.judgeName +
                        "\n UID: " + cc.judicialUID +
                        "\n cтатус: " + cc.status + "\n\n\n"
                }
                
                let item = name + "\n" + vkUsers + "\n" + cases
                body += item + "\n\n\n"
            }
        }
        
        
        vc.setMessageBody(body, isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}
