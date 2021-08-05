//
//  SearchByCityViewController.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 4/8/21.
//

import UIKit
import MapboxGeocoder

protocol  SearchWeatherByCityViewControllerDelegate: AnyObject{
    func setLatitudeLongitudeFromSearchWeatherByCityViewController(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
}

class SearchWeatherByCityViewController: UITableViewController {
    let geocoder = Geocoder.shared
    var cities: [GeocodedPlacemark]?
    var searchBar: UISearchBar?
    weak var searchByCityDelegate: SearchWeatherByCityViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    deinit {
        print("SearchWeatherByCityViewController is deallocated")
    }
}

extension SearchWeatherByCityViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar = searchBar
        if let searchText = searchBar.text , searchText.count > 0{
            let options = ForwardGeocodeOptions(query: searchText)
            let task = geocoder.geocode(options) { placemarks, attribution, error in
                if error != nil{
                    print(error)
                    return
                }
                
                self.cities = placemarks
                self.tableView.reloadData()
            }
            
        }else{ // cross pressed
            self.cities = []
            self.tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//MARK:- table view datasource
extension SearchWeatherByCityViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cityCellIdentifier, for: indexPath)
        cell.textLabel?.text = cities?[indexPath.row].name
        return cell
    }
}

//MARK:- Table view delegate
extension SearchWeatherByCityViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar?.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
        tableView.deselectRow(at: indexPath, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let coordinate = self.cities?[indexPath.row].location?.coordinate{
                print("Coordinate of \(self.cities?[indexPath.row].name) is \(coordinate.latitude) and \(coordinate.longitude)")
                self.searchByCityDelegate?.setLatitudeLongitudeFromSearchWeatherByCityViewController(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
            self.navigationController?.popViewController(animated: false)
        }
        
    }
}
