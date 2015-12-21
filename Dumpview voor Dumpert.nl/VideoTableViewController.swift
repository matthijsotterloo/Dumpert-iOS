//
//  VideoTableViewController.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 13-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import UIKit
import Foundation

var selectedVideo: Int = 0
var videos = [Video]()
let videoAmount: Int = 10
var videoCount: Int = 0


class VideoTableViewController: UITableViewController {
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "VideoTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "video")
        tableView.rowHeight = 120
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "Logo.png")
        self.navigationItem.titleView = imageView
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        //Parse 30 new video's
        print(DumpertApi.getRecentVideos(videoAmount))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videos.count
    }
    
    func refresh(sender:AnyObject) {
        videoCount = 0
        videos.removeAll()
        parseVideoXml(DumpertApi.getXML(DumpertApi.getRecentVideos(videoAmount))!)
        self.refreshControl!.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: VideoTableViewCell = tableView.dequeueReusableCellWithIdentifier("video", forIndexPath: indexPath) as! VideoTableViewCell
        let video = videos[indexPath.row]
        
        cell.thumb?.image = video.thumb
        cell.title?.text = video.title
        cell.views?.text = video.views
        cell.date?.text = video.date
        cell.kudos?.text = video.kudos
        
        // If kudos is negative value change color to red.
        if video.kudos.rangeOfString("-") != nil {
            cell.kudos?.textColor = UIColor.redColor()
        } else {
            cell.kudos?.textColor = UIColor(red: 110/256, green: 187/256, blue: 47/256, alpha: 1)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(videos.count >= videoCount){
            let lastRowIndex: Int = tableView.numberOfRowsInSection(0) - 1
            if (indexPath.row == lastRowIndex) {
                // This is the last cell
                let video = videos[indexPath.row]
                parseVideoXml(DumpertApi.getXML(DumpertApi.getRecentVideos(String(video.id)))!)
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.performSegueWithIdentifier("videoSegue", sender: self)
        
    }
    
    func parseVideoXml(data: NSData) {

        let xml = SWXMLHash.parse(data)
    
        for video in xml["videos"]["video"] {
            if(!video["nsfw"]){
                Image.downloadImage(NSURL(string: video["thumb"].element!.text!)!, completion: { (image) -> Void in
                    
                    let id = video["id"].element!.text!
                    let thumb = image
                    let title = video["title"].element!.text!
                    let brief = video["brief"].element!.text!
                    let date = Functions.convertDateFormater(video["date"].element!.text!)
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
                    
                    videoCount++
                    videos.append(Video(id: id, thumb: thumb!, title: title, brief: brief, date: date, videoLinkLow: videoLinkLow!, videoLink: videoLink!, tags: tags, views: views, kudos: kudos))
                    videos.sort { $0.id < $1.id }
                    
                    self.tableView.reloadData()
                })
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "videoSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            
            selectedVideo = indexPath!.row
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)
            
            //Custom back button text and color
            let backItem = UIBarButtonItem()
            backItem.title = "Video's"
            
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            navigationItem.backBarButtonItem = backItem
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let nav = self.navigationController?.navigationBar
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "AvenirNextLTPro-Bold", size: 30)!
        ]
        
        nav?.topItem?.title      = "DUMPVIEW"
        nav?.barTintColor        = UIColor(red: 103.0/255.0, green: 193.0/255.0, blue: 33.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
}
