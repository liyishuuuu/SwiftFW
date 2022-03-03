//
//  QuoteDetailContract.swift
//  VIPER-SimpsonQuotes
//
//  Created by Zafar on 1/2/20.
//  Copyright © 2020 Zafar. All rights reserved.
//

import UIKit

// MARK: View Output (Presenter -> View)
protocol PresenterToViewQuoteDetailProtocol: AnyObject {
    
    func onGetImageFromURLSuccess(_ quote: String, character: String, image: UIImage)
    func onGetImageFromURLFailure(_ quote: String, character: String)
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterQuoteDetailProtocol: AnyObject {
    
    var view: PresenterToViewQuoteDetailProtocol? { get set }
    var interactor: PresenterToInteractorQuoteDetailProtocol? { get set }
    var router: PresenterToRouterQuoteDetailProtocol? { get set }

    func viewDidLoad()
    
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorQuoteDetailProtocol: AnyObject {
    
    var presenter: InteractorToPresenterQuoteDetailProtocol? { get set }
    
    var quote: Quote? { get set }
    
    func getImageDataFromURL()
    
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterQuoteDetailProtocol: AnyObject {
    
    func getImageFromURLSuccess(quote: Quote, data: Data?)
    func getImageFromURLFailure(quote: Quote)
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterQuoteDetailProtocol: AnyObject {
    
    static func createModule(with quote: Quote) -> UIViewController
}
