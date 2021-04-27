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
    
    var events:[event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate=self
        tableView.dataSource=self
        eventManager.delegate=self
        
        
        
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdenifier)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150;

    }


}
extension SearchViewControll: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdenifier, for: indexPath) as! ResultCell
        
        cell.eventNameLabel.text=events[indexPath.row].short_title
        cell.locationLabel.text=events[indexPath.row].venue.display_location
        cell.eventImageView.load(urlString: events[indexPath.row].performers[0].image)
        cell.eventImageView.layer.cornerRadius=cell.eventImageView.frame.size.width/8
        
        let dateString = events[indexPath.row].datetime_local
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss"
        let date=dateFormatter.date(from: dateString)
        let displayFormatter=DateFormatter()
        displayFormatter.dateFormat="EEEE, dd MMM yyyy \nhh:mm a"

        cell.timeLabel.text="\(displayFormatter.string(from: date!))"
        
        return cell;

        
        
    }
    
    
}

extension SearchViewControll: EventManagerDelegete{
    func didUpdate(eventManager: EventManager, events: [event]) {
        DispatchQueue.main.async {
            print(events)
            self.events=events
            self.tableView.reloadData()
        }
    }
    
    func didUpdate(_ events: [event]) {
        DispatchQueue.main.async {
            self.events=events
            self.tableView.reloadData()
        }
    }
    
    func didFailUpdate(error: Error) {
        print(error)
    }
    
    
}




extension SearchViewControll: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        eventManager.fetchEvents(query: searchBar.text!, page: 1)
        
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        eventManager.fetchEvents(query: searchBar.text!, page: 1)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text=""
    }
}



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
