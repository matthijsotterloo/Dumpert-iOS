//
//  VideoTableViewController.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 13-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import UIKit

var selectedVideo: Int = 0
var videos = [Video]()


class VideoTableViewController: UITableViewController {
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alertView = SCLAlertView()
        let reachability: Reachability
        
        //Initialize reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "video")
        tableView.rowHeight = 75
        
        //Add dumpert logo to header view
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "Logo.png")
        self.navigationItem.titleView = imageView
        
        //Bind pull to refresh to action
        self.refreshControl?.addTarget(self, action: "refreshVideos:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Check for connection
        reachability.whenReachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    print("Connected via WiFi")
                    //Clear old videos from table and load new one
                    videos.removeAll()
                    self.parseVideoXml(DumpertApi.getXML(DumpertApi.getRecentVideos(30))!)
                    self.tableView.reloadData()
                } else {
                    print("Connected via Cellular")
                    //Clear old videos from table and load new one
                    videos.removeAll()
                    self.parseVideoXml(DumpertApi.getXML(DumpertApi.getRecentVideos(30))!)
                    self.tableView.reloadData()
                }
            }
        }
        
        // When no network connection
        reachability.whenUnreachable = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                print("No internet connection available")
                alertView.showCloseButton = false
                alertView.showWarning("Geen internet", subTitle: "Voor het gebruik van Dumpert viewer is een internet verbinding vereist.")
            }
        }
        
        //Start notifier !IMPORTANT
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func refreshVideos(sender:AnyObject)
    {
        videos.removeAll()
        parseVideoXml(DumpertApi.getXML(DumpertApi.getRecentVideos(30))!)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videos.count
        //return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCellWithIdentifier("video", forIndexPath: indexPath) as! TableViewCell
        let video = videos[indexPath.row]
        
        //cell.textLabel?.text = video.title
        //cell.imageView?.image = video.thumb
        cell.thumb?.image = video.thumb
        cell.title?.text = video.title
        cell.views.text = video.views
        cell.kudos.text = video.kudos
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //let lastSectionIndex: Int = tableView.numberOfSections - 1
        let lastRowIndex: Int = tableView.numberOfRowsInSection(0) - 1
        if (indexPath.row == lastRowIndex) {
        // This is the last cell
        let video = videos[indexPath.row]

        print(video.id)
        parseVideoXml(DumpertApi.getXML(DumpertApi.getRecentVideos(String(video.id)))!)
        self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("videoSegue", sender: self)
        
    }

    func parseVideoXml(data: NSData){

        let xml = SWXMLHash.parse(data)

        //var videos = [Video]()
        
        for video in xml["videos"]["video"] {
            //print(video["thumb"].element!.text!)
            
            if(!video["nsfw"]){
                Image.downloadImage(NSURL(string: video["thumb"].element!.text!)!, completion: { (image) -> Void in
                    
                    let id = video["id"].element!.text!
                    let thumb = image
                    let title = video["title"].element!.text!
                    let brief = video["brief"].element!.text!
                    let date = video["date"].element!.text!
                    let videoLinkLow = NSURL(string: video["videoLinkLow"].element!.text!)
                    let videoLink = NSURL(string: video["videoLink"].element!.text!)
                    
                    var tags = ""
                    
                    if(video["tags"]){
                        tags = video["tags"].element!.text!
                    }
                    
                    var views = video["views"].element!.text!
                    let kudos = video["kudos"].element!.text!
                    
                    // If more then 1.000 views switch to K.
                    if(Double(views) >= 10000){
                        views = String(round(Double(views)!/1000.0)/10.0) + "K"
                    }
                    
                    
                    videos.append(Video(id: id, thumb: thumb!, title: title, brief: brief, date: date, videoLinkLow: videoLinkLow!, videoLink: videoLink!, tags: tags, views: views, kudos: kudos))
                    videos.sort { $0.id < $1.id }
                    self.tableView.reloadData()
                })
            }
            
        }
    }

    // MARK: - Navigation

    //Prepare for segue to detail view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "videoSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            
            selectedVideo = indexPath!.row
            
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)
            
            //Custom back button text
            let backItem = UIBarButtonItem()
            backItem.title = "Terug"
            navigationItem.backBarButtonItem = backItem
        }
        
    }
}
