//
//  QuotesContract.swift
//  VIPER-SimpsonQuotes
//
//  Created by Zafar on 1/2/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit

// MARK: View Output (Presenter -> View)
protocol PresenterToViewQuotesProtocol: AnyObject {
    func onFetchQuotesSuccess()
    func onFetchQuotesFailure(error: String)
    func deselectRowAt(row: Int)
}

// MARK: View Input (View -> Presenter)
protocol ViewToPresenterQuotesProtocol: AnyObject {
    var view: PresenterToViewQuotesProtocol? { get set }
    var interactor: PresenterToInteractorQuotesProtocol? { get set }
    var router: PresenterToRouterQuotesProtocol? { get set }
    var quotesStrings: [String]? { get set }
    
    func viewDidLoad()
    func refresh()
    func numberOfRowsInSection() -> Int
    func textLabelText(indexPath: IndexPath) -> String?
    func didSelectRowAt(index: Int)
    func deselectRowAt(index: Int)
}

// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorQuotesProtocol: AnyObject {
    var presenter: InteractorToPresenterQuotesProtocol? { get set }
    
    func loadQuotes()
    func retrieveQuote(at index: Int)
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterQuotesProtocol: AnyObject {
    func fetchQuotesSuccess(quotes: [Quote])
    func fetchQuotesFailure(errorCode: Int)
    func getQuoteSuccess(_ quote: Quote)
    func getQuoteFailure()
}

// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterQuotesProtocol: AnyObject {
    func pushToQuoteDetail(on view: PresenterToViewQuotesProtocol, with quote: Quote)
}
