//
//  QuotesRouter.swift
//  VIPER-SimpsonQuotes
//
//  Created by Zafar on 1/2/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit

class QuotesRouter: PresenterToRouterQuotesProtocol {
    
    static func createModuleFromNib() -> UIViewController {
        
        print("QuotesRouter creates the Quotes module.")
        
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let testVIPERVC = sb.instantiateViewController(withIdentifier: "testVIPERViewController") as! TestVIPERViewController
        
        let viewController = testVIPERVC
        let presenter: ViewToPresenterQuotesProtocol & InteractorToPresenterQuotesProtocol = QuotesPresenter()
        viewController.presenter = presenter
        viewController.presenter?.router = QuotesRouter()
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = QuotesInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        return viewController
    }
    
    // MARK: - Navigation
    func pushToQuoteDetail(on view: PresenterToViewQuotesProtocol, with quote: Quote) {
        print("QuotesRouter is instructed to push QuoteDetailViewController onto the navigation stack.")
        let quoteDetailViewController = QuoteDetailRouter.createModule(with: quote)
            
//        let viewController = view as! QuotesViewController
        let viewController = view as! TestVIPERViewController
        viewController.navigationController?.pushViewController(quoteDetailViewController, animated: true)
    }
}
