//
//  TableViewController.swift
//  BRYHNH
//
//  Created by Bill Skrzypczak on 10/6/14.
//  Copyright (c) 2014 Bill Skrzypczak. All rights reserved.
//

import UIKit
import AVKit






// Define the class for the table view
// *****


class TableViewController: UITableViewController, XMLParserDelegate {
    
    
    
    
    // Step 1 - Define the variables, arrays, and dictionaries
    // *****
    
    
    
    var parser = XMLParser()              // Var for temp storage of parser data
    
    var feeds = NSMutableArray()            // Array for temp storage of episodes
    
    var elements = NSMutableDictionary()    // Dict for temp storage of episode elements
    
    var element = NSString()                // Var to hold data from current element
    
    var ftitle = NSMutableString()          // Var to hold current episode title
    
    var link = NSMutableString()            // Not sure I need this ???
    
    var fdescription = NSMutableString()    // Var to hold current episode song list
    
    var currentList = String()              // Var used to pass current song list thru segue
    
    var feedEnclosure = NSMutableString()   // Var used to store path of audio stream
    
    var mystream = NSMutableString()        // Var that will be used to store current audio stream
    
    // Unwind Segue
    @IBAction func unwindToEpisodes( sender:UIStoryboardSegue){}
    
    
    // Run the parser methods when the App Starts up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Step 2 - Setup the RSS Feed and Initialize the Parameters
        // *****
        feeds = []
        let url = URL(string: "http://www.bestradioyouhaveneverheard.com/podcasts/index.xml")
        _ = URLRequest(url:url! as URL)
        parser = XMLParser (contentsOf: url! as URL)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
        
    }
    
    // Step 3 -  Define your Methods/Functions
    // ***************************************
    
    // Initialize variables to "nil" when <item> tag is encountered
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        element = elementName as NSString
        
        if (element as NSString).isEqual(to: "item") {
            elements = NSMutableDictionary()
            elements = [:]
            ftitle = NSMutableString()
            ftitle = ""
            link = NSMutableString()
            link = ""
            fdescription = NSMutableString()
            fdescription = ""
            mystream = NSMutableString()
            mystream = ""
            feedEnclosure = NSMutableString()
            feedEnclosure = ""
            
            
        }
        // Magic code to get enclosure url
        
        if elementName == "enclosure" {
            var attrsUrl = attributeDict as [String: NSString]
            let urlPic = attrsUrl["url"]
            elements.setObject(urlPic!, forKey: "enclosure" as NSCopying)
            
            
        }
    }
    
    // If the tag is not empty load a given key-value pair to the dictionary
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if (elementName as NSString).isEqual(to: "item") {
            
            if (ftitle != "") {
                elements.setObject(ftitle, forKey: "title" as NSCopying)
                //print(ftitle) // Confirm key-value pair loaded
            }
            
            if (link != "") {
                elements.setObject(link, forKey: "link" as NSCopying)
                //print(link) // Confirm key-value pair loaded
            }
            
            
            if (fdescription != "") {
                elements.setObject(fdescription, forKey: "itunes:summary" as NSCopying)
                //print(fdescription) // Confirm key-value pair loaded
            }
            
            if (feedEnclosure != "") {
                elements.setObject(feedEnclosure, forKey: "enclosure" as NSCopying)
                //print(feedEnclosure) // Confirm key-value pair loaded
            }
            
            
            feeds.add(elements)
            
        }
        
    }
    
    // Append the text from the element to the end of the receiver
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        
        if element.isEqual(to: "title"){
            ftitle.append(string)
            
        }else if element.isEqual(to: "link"){
            link.append(string)
            
        }else if element.isEqual(to: "itunes:summary"){
            fdescription.append(string)
            
        }
        
    }
    
    
    
    // Now reload all the data
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
        
    }
    
    
    //  MARK ---> Define The Table View
    //
    
    
    // Define the number of sections in the tableview
    //
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        return 1
    }
    
    
    
    // Define the number of rows to display based on the number of items loaded into the array feeds
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    
    // Populate the cell with data elements from parser Recycle the last cell
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        // Load an image file into the left margin
        //
        let image : UIImage = UIImage(named: "300px-banner.png")!
        
        cell.imageView?.image = image
        
        // Load the parser data from the title element
        //
        
        
        let feed = feeds.object(at: indexPath.row) as! NSMutableDictionary
        cell.textLabel?.text = feed.value(forKey: "title") as? String
        
        
        
        // Load 3 lines of data for each cell
        //
        cell.textLabel?.numberOfLines = 3
        
        // Test feed data
        // print(feed)
        
        return cell
        
    }
    
    // Segue Test Area
    
    // Only grab the data at the selected row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Test print to check what row this is
        print("Row is =", indexPath.row)
        
        
        // perform the segue called myPlaylist
        //performSegue(withIdentifier: "myPlaylist", sender: nil)
        // perform the segue called myAudioPlayer
        //performSegue(withIdentifier: "myAudioplayer", sender: nil)
        
    }
    
    // prepare the data to be passed thru the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Tell the data where to go
        let mysongs: SecondViewController = (segue.destination as! SecondViewController )
        let myaudio: SecondViewController = (segue.destination as! SecondViewController )
        
        // Use the data in the current row
        let indexPath = self.tableView.indexPathForSelectedRow
        
        // Create a constant to hold the songlist you want to pass
        mysongs.currentList = ((feeds.object(at: (indexPath?.row)!) as! NSMutableDictionary).allValues[0] as! String)
        
        // Create a constant to hold the mp3 file you want to pass
        myaudio.mystream = (feeds.object(at: (indexPath?.row)!) as! NSMutableDictionary).value(forKey: "enclosure") as? String
        //        // Pass the data
        //
        //        // Test print to check data
        //print(mysongs.currentList)
        //print(myaudio.mystream)
        
    }
    
    
    
}
