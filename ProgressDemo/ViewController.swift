//
//  ViewController.swift
//  ProgressDemo
//
//  Created by qingjie on 10/29/15.
//  Copyright © 2015 Retrieve LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,NSURLSessionDownloadDelegate{

 
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressCount: UILabel!
    
    var task :NSURLSessionTask!
    
    var percentageWritten:Float = 0.0
    var taskTotalBytesWritten = 0
    var taskTotalBytesExpectedToWrite = 0
    
    lazy var session : NSURLSession = {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        config.allowsCellularAccess = false
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        return session
    }()
    
    override func viewDidLoad() {
        
        progressBar.setProgress(0.0, animated: true)  //set progressBar to 0 at start
    }
    
    @IBAction func doElaborateHTTP (sender:AnyObject!) {
        
        progressCount.text = "0%"
        if self.task != nil {
            return
        }
        
        let s = "http://www.qdtricks.com/wp-content/uploads/2015/02/hd-wallpapers-1080p-for-mobile.png"
        let url = NSURL(string:s)!
        let req = NSMutableURLRequest(URL:url)
        let task = self.session.downloadTaskWithRequest(req)
        self.task = task
        task.resume()
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        print("downloaded \(100*writ/exp)")
        taskTotalBytesWritten = Int(writ)
        taskTotalBytesExpectedToWrite = Int(exp)
        percentageWritten = Float(taskTotalBytesWritten) / Float(taskTotalBytesExpectedToWrite)
        progressBar.progress = percentageWritten
        progressCount.text = String(format: "%.01f", percentageWritten*100) + "%"
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        // unused in this example
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        print("completed: error: \(error)")
    }
    
    // this is the only required NSURLSessionDownloadDelegate method
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        
        let documentsDirectoryURL =  NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first 
        print("Finished downloading!")
        print(documentsDirectoryURL)

    }

}

