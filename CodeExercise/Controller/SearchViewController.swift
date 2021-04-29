//
//  SearchViewController.swift
//  CodeExercise
//
//  Created by Hart on 4/26/21.
//

import UIKit

class SearchViewControll: UIViewController{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var eventManager = EventManager()
    var page=1
    var isLoadMore=false
    var events:[event] = []
    var favorites:[String:Bool]=[:]
    var selectedIndex:Int=0
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegate
        searchBar.delegate=self
        tableView.delegate=self
        tableView.dataSource=self
        eventManager.delegate=self
        
        
        //register tableview cell
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdenifier)
        //tableView auto sizing
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150;

    }

    override func viewWillAppear(_ animated: Bool) {
        //load favorites from user defaults
        NSLog("Reload favorites and tableview")
        if let dic=defaults.object(forKey: K.favoriteSetName) as? [String:Bool]{
                favorites=dic
        }
        self.tableView.reloadData()
    }

}

//MARK: TableView delegate

extension SearchViewControll:UITableViewDelegate{
    
    
    
    // load more data when scroll to the end
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        if !isLoadMore && offset >= scrollView.contentSize.height-scrollView.frame.height{
            NSLog("Fetch new data")
            isLoadMore=true
            page+=1
            eventManager.fetchEvents(query: searchBar.text!, page: page)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("Cell \(indexPath.row) is selected")
        selectedIndex=indexPath.row
        performSegue(withIdentifier: K.segue.searchToEvent, sender: self)

        
    }
    
    // pass all parameters to EventView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier==K.segue.searchToEvent){
            
            let selected=events[selectedIndex]
            let VC=segue.destination as! EventViewController
            VC.eventName=selected.title
            VC.imageUrl=selected.imageUrl
            VC.time=selected.time
            VC.location=selected.location
            VC.id=selected.id
            VC.url=selected.ticketUrl
            
        }
    }
}






// MARK: TableView DataSource


extension SearchViewControll: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    //set up cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdenifier, for: indexPath) as! ResultCell
        
        let cur=events[indexPath.row]
        cell.eventNameLabel.text=cur.title
        cell.locationLabel.text=cur.location
        cell.eventImageView.load(urlString: cur.imageUrl)
        cell.eventImageView.layer.cornerRadius=cell.eventImageView.frame.size.width/8
        //check if is favorited
        if favorites[String(cur.id)] ?? false {
            cell.favoriteMark.isHidden=false
        }else{
            cell.favoriteMark.isHidden=true
        }

        // formate time
        let date=events[indexPath.row].time
        let displayFormatter=DateFormatter()
        displayFormatter.dateFormat="EEEE, dd MMM yyyy \nhh:mm a"
        cell.timeLabel.text="\(displayFormatter.string(from: date))"
        
        return cell;

    }
    
    
}

// MARK: EventManager Delegate

extension SearchViewControll: EventManagerDelegate{

    //update var events after fetch
    func didUpdate(_ eventJson:[eventJson]){
        NSLog("Did Update")
        DispatchQueue.main.async {
            //check if search or loadmore
            if(self.isLoadMore){
                self.events.append(contentsOf: EventsModel(events_response:eventJson).events)
                self.isLoadMore=false
            }else{
                self.events=EventsModel(events_response:eventJson).events
                
            }
            self.tableView.reloadData()
        }
    }
    
    func didFailUpdate(error: Error) {
        print(error)
    }
    
    
}



// MARK: SearchBar Delegate
extension SearchViewControll: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        //initial page to 1
        self.page=1
        eventManager.fetchEvents(query: searchBar.text!, page: 1)
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        //initial page to 1
        self.page=1
        eventManager.fetchEvents(query: searchBar.text!, page: 1)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text=""
    }
}


// MARK: UIImage extension: load()
extension UIImageView {
    func load(urlString : String) {
        guard let url = URL(string: urlString)else {
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
