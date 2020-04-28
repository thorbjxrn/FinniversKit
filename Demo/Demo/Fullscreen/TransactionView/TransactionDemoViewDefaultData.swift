//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

public struct TransactionModel: TransactionViewModel {
    public var title: String
    public var header: TransactionHeaderViewModel?
    public var alert: TransactionAlertViewModel?
    public var steps: [TransactionStepViewModel]
}

public struct TransactionHeaderModel: TransactionHeaderViewModel {
    public var adId: String
    public var title: String?
    public var registrationNumber: String?
    public var imagePath: String?
}

public struct TransactionAlertModel: TransactionAlertViewModel {
    public var title: String
    public var body: String
    public var imageIdentifier: String
}

public struct TransactionStepModel: TransactionStepViewModel {
    public var state: TransactionStepViewState
    public var style: TransactionStepView.CustomStyle?
    public var main: TransactionStepContentViewModel?
    public var detail: TransactionStepContentViewModel?
}

public struct TransactionStepContentModel: TransactionStepContentViewModel {
    public var title: String?
    /*
     If body contains a link (<a href>), the backend will assign the same content to nativeBody, but without the (<a href>) link.
     Instead the nativeButton will also be present in the payload with the action and link as an replacement.

     This is to avoid having the client render both a link and a nativeButton.

     See line 56-66 in BothPartiesConfirmedHandoverDemoViewModel.swift as an example
    */
    public var body: NSAttributedString?
    public var nativeBody: NSAttributedString?
    public var nativeButton: TransactionActionButtonViewModel?
    public var primaryButton: TransactionActionButtonViewModel?
}

public struct TransactionActionButtonModel: TransactionActionButtonViewModel {
    public var text: String
    public var style: String
    public var action: String?
    public var url: String?
    public var fallbackUrl: String?
}

public struct TransactionDemoViewDefaultData {
    private var currentState = -1

    // swiftlint:disable cyclomatic_complexity
    mutating func getState() -> TransactionViewModel {
        if currentState == 12 {
            self.currentState = -1
        }

        currentState += 1

        switch currentState {
        case 0:
            print("State: contract not created")
            return TransactionDemoViewDefaultData.ContractNotCreatedDemoViewModel
        case 1:
            print("State: contract created")
            return TransactionDemoViewDefaultData.ContractCreatedDemoViewModel
        case 2:
            print("State: buyer invited")
            return TransactionDemoViewDefaultData.BuyerInvitedDemoViewModel
        case 3:
            print("State: seller only signed")
            return TransactionDemoViewDefaultData.SellerOnlySignedDemoViewModel
        case 4:
            print("State: buyer only signed")
            return TransactionDemoViewDefaultData.BuyerOnlySignedDemoViewModel
        case 5:
            print("State: both parties signed")
            return TransactionDemoViewDefaultData.BothPartiesSignedDemoViewModel
        case 6:
            print("State: awaiting payment")
            return TransactionDemoViewDefaultData.AwaitingPaymentDemoViewModel
        case 7:
            print("State: payment completed")
            return TransactionDemoViewDefaultData.PaymentCompletedDemoViewModel
        case 8:
            print("State: buyer confirmed handover")
            return TransactionDemoViewDefaultData.BuyerConfirmedHandoverDemoViewModel
        case 9:
            print("State: seller confirmed handover")
            return TransactionDemoViewDefaultData.SellerConfirmedHandoverDemoViewModel
        case 10:
            print("State: payment completed - both parties confirmed handover")
            return TransactionDemoViewDefaultData.BothPartiesConfirmedHandoverDemoViewModel
        case 11:
            print("State: ad expired - show Nettbil integration")
            return TransactionDemoViewDefaultData.AdExpiredDemoViewModel
        case 12:
            print("State: payment cancelled")
            return TransactionDemoViewDefaultData.PaymentCancelledDemoViewModel
        default:
            fatalError("No model exists for step \(currentState)")
        }
    }
}