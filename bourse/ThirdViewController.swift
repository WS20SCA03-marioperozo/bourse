//
//  ButtonsViewController.swift
//  bourse
//
//  Created by Mario Perozo on 6/5/20.
//  Copyright © 2020 Mario Perozo. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    var tickerSymbol: String? = nil;
    
    @IBOutlet weak var exchangeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //https://finnhub.io/api/v1/stock/profile2?symbol=\(tickerSymbol!)&token=brbqirfrh5rb7je2trmg
        
        let address: String = "https://finnhub.io/api/v1/stock/profile2?symbol=IBM&token=brbqirfrh5rb7je2trmg";
        
        guard let url: URL = URL(string: address) else {
            print("Could not create URL from address \"\(address)\".");
            return;
        }
        
        guard let webPage: String = textFromURL(url: url) else {
            print("Received nothing from URL \"\(url)\".");
            return;
        }
        
        let s: String = "\"exchange\":";
        guard let range: Range<String.Index> = webPage.range(of: s) else {
            print("\(s) not found");
            return;
        }
        
        let charAfterColon: String.Index = range.upperBound; //the character after the ":"
        let restOfPage: Substring = webPage[charAfterColon...];
        
        guard let comma: String.Index = restOfPage.firstIndex(of: ",") else {
            print("Couldn't find ,");
            return;
        }
        
        let exchangeAsString: Substring = restOfPage[..<comma];
        
        guard let exchange: String = String(exchangeAsString) else {
            print("Exchange was not a String");
            return;
        }
        
        exchangeLabel.text = String(format: "The current price of \(tickerSymbol!) is USD %.2f.", exchange);
    }
    
    func textFromURL(url: URL) -> String? {
        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0);
        var result: String? = nil;
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            if let error: Error = error { //I hope this if is false.
                print(error);
            }
            if let data: Data = data {    //I hope this if is true.
                result = String(data: data, encoding: String.Encoding.utf8);
            }
            semaphore.signal();   //Cause the semaphore's wait method to return.
        }
        
        task.resume();    //Try to download the web page into the Data object, then execute the closure.
        semaphore.wait(); //Wait here until the download and closure have finished executing.
        return result;    //Do this return after the closure has finished executing.
    }
}



