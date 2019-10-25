//
//  MapViewController.swift
//  Tinder Clone
//
//  Created by trioangle on 09/06/18.
//  Copyright © 2018 Anonymous. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class MapViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var infoWindowView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var currentCoordinates = CLLocationCoordinate2D()
    
    var locationManager: CLLocationManager!
    
    var marker = GMSMarker()
    var addressDict = [String:Any]()
    
    let autocompleteController = GMSAutocompleteViewController()
    
    func navigationCustom() {
        self.navigationController?.isNavigationBarHidden = false
//        self.navigationItem.title = "Settings"
//        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(SettingViewController.doneSelected))
        let myLocationButtonView = UIBarButtonItem.init(image: UIImage(named: "locationMap"), style: .plain, target: self, action: #selector(MapViewController.myLocationSelected))
        self.navigationItem.rightBarButtonItem = myLocationButtonView
        
        let closeButtonView = UIBarButtonItem.init(image: UIImage(named: "cancelMap"), style: .plain, target: self, action: #selector(MapViewController.cancelSelected))
        self.navigationItem.leftBarButtonItem = closeButtonView
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 15, green: 115, blue: 235)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 15, green: 115, blue: 235)
        
        self.navigationController?.navigationBar.barTintColor = self.view.backgroundColor
//        navigationController?.navigationBar.tintColor = Themes.sharedIntance.ReturnThemeColor()
        self.navigationItem.titleView = self.searchBar
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.isNavigationBarHidden = true
        

        navigationCustom()
        
        autocompleteController.delegate = self

        // Do any additional setup after loading the view.
        
        if let txfSearchField = searchBar.value(forKey: "_searchField") as? UITextField {
            txfSearchField.clipsToBounds = true
            txfSearchField.layer.cornerRadius = 2.0
//            txfSearchField.borderStyle = .none
            txfSearchField.backgroundColor = UIColor(red: 200.0, green: 200.0, blue: 200.0, alpha: 1.0)
//            txfSearchField.backgroundColor = UIColor.lightGray
        }
        searchBar.searchBarStyle = .minimal
        
        currentCoordinates = SharedVariables.sharedInstance.currentCoordinates

        
        mapView.delegate = self
        
        let position = currentCoordinates
        marker = GMSMarker(position: position)
        marker.icon = #imageLiteral(resourceName: "locationMap.png")
        marker.appearAnimation = .pop
        marker.map = self.mapView
        
        mapView.selectedMarker = marker
        
        let camera = GMSCameraPosition.camera(withLatitude: currentCoordinates.latitude, longitude: currentCoordinates.longitude, zoom: 10.0)
        mapView.camera = camera
        
        getAddressForCoordinates(coordinate: currentCoordinates)
        
        // Creates a marker in the center of the map.
//        let position = CLLocationCoordinate2D(latitude: currentCoordinates.latitude, longitude: currentCoordinates.longitude)
//        marker = GMSMarker(position: position)
//        marker.icon = #imageLiteral(resourceName: "locationMap.png")
//        marker.map = mapView
        
        
//        updateCurrentLocation()
        
//        self.view.addSubview(mapView)
//        self.view.bringSubview(toFront: mapView)
    }
    
    func showMap(place: GMSPlace) {
        
//        mapView = self.view.subviews[1] as! GMSMapView
//        mapView.delegate = self
        
        
        mapView.clear()
        let position = place.coordinate
        marker = GMSMarker(position: position)
        marker.icon = #imageLiteral(resourceName: "locationMap.png")
        marker.appearAnimation = .pop
        marker.map = self.mapView
        
        mapView.selectedMarker = marker
        
         let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 10.0)
        mapView.camera = camera
        
        
        
        
        addressDict = [String:Any]()
        addressDict["default"] = "Not Active"
        addressDict["id"] = ""
        addressDict["Name"] = place.name
        addressDict["location"] = place.formattedAddress
        addressDict["latitude"] = "\(place.coordinate.latitude)"
        addressDict["longitude"] = "\(place.coordinate.longitude)"
        
        print(addressDict)
        
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func myLocationButtonAction(_ sender: Any) {
        
        
        currentCoordinates = SharedVariables.sharedInstance.currentCoordinates
        
        mapView.clear()
        
        let camera = GMSCameraPosition.camera(withLatitude: currentCoordinates.latitude, longitude: currentCoordinates.longitude, zoom: 10.0)
        mapView.animate(to: camera)
        
        getAddressForCoordinates(coordinate: currentCoordinates)
        
        
    }
    
    @objc func myLocationSelected() {
        myLocationButtonAction("")
    }
    
    @objc func cancelSelected() {
        cancelButtonAction("")
    }
    
    func getAddressForCoordinates(coordinate: CLLocationCoordinate2D) {
        
        let position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        marker = GMSMarker(position: position)
        marker.icon = #imageLiteral(resourceName: "locationMap.png")
        marker.appearAnimation = .pop
        marker.map = mapView
        
        var params = [String:String]()
        StaticData.latitude=String(describing: coordinate.latitude)
        StaticData.langitude=String(describing: coordinate.longitude)
        params["latlng"] = "\(coordinate.latitude),\(coordinate.longitude)"
        params["key"] = k_GoogleAPI_Key
        params["language"] = "en"
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json"
        
        let Header:HTTPHeaders = [:]
        
        Alamofire.request(url as String, method: .get, parameters:params,headers:Header).responseJSON { (response) in do {
            
            let responseDict = try JSONSerialization.jsonObject(
                
                with: response.data!,
                
                options: JSONSerialization.ReadingOptions.mutableContainers
                ) as? NSDictionary
            
            print(responseDict!)
            
            var cityName:String?
            var countryName:String?
            
            if ((responseDict?["results"] as? [[String:Any]])?.count)! > 0 {
                
                let addressArray = (responseDict!["results"] as! [[String:Any]])[0]["address_components"] as! [[String:Any]]
                for addressDict in addressArray {
                    print(addressDict)
                    if (addressDict["types"]! as! [String])[0] == "administrative_area_level_2" {
                        print("CITY \(addressDict["long_name"]!)")
                        //                        self.cityNameLabel.text = "\(addressDict["long_name"]!)"
                        cityName = "\(addressDict["long_name"]!)"
                    }
                    if (addressDict["types"]! as! [String])[0] == "country" {
                        print("COUNTRY \(addressDict["long_name"]!)")
                        //                        self.addressLabel.text = "\(addressDict["long_name"]!)"
                        countryName = "\(addressDict["long_name"]!)"
                    }
                }
                if cityName != nil {
                    self.cityNameLabel.text = cityName!
                }
                else {
                    for addressDict in addressArray {
                        if (addressDict["types"]! as! [String])[0] == "administrative_area_level_1" {
                            print("CITY \(addressDict["long_name"]!)")
                            cityName = "\(addressDict["long_name"]!)"
                        }
                    }
                    if cityName != nil {
                        self.cityNameLabel.text = cityName!
                    }
                    else {
                        self.cityNameLabel.text = ""
                    }
                }
                if countryName != nil {
                    self.addressLabel.text = countryName!
                }
                else {
                    self.addressLabel.text = ""
                }
                
                self.mapView.selectedMarker = self.marker
                
                self.addressDict = [String:Any]()
                self.addressDict["default"] = "Not Active"
                self.addressDict["id"] = ""
                self.addressDict["Name"] = self.cityNameLabel.text
                self.addressDict["location"] = self.addressLabel.text
                self.addressDict["latitude"] = "\(coordinate.latitude)"
                self.addressDict["longitude"] = "\(coordinate.longitude)"
                
                
            }
            
            
        }
        catch let error as NSError {
            print("A JSON parsing error occurred, here are the details:\n \(error)")
            }
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 10.0)
        mapView.animate(to: camera)
    }
    
    
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("SELECTED LAT \(coordinate.latitude)")
        print("SELECTED LONG \(coordinate.longitude)")
        
        mapView.clear()
        
        getAddressForCoordinates(coordinate: coordinate)
        
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
//                    print(pm.country)
//                    print(pm.locality)
//                    print(pm.subLocality)
//                    print(pm.thoroughfare)
//                    print(pm.postalCode)
//                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
//                        self.cityNameLabel.text = addressString
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
//                        self.addressLabel.text = addressString
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    
                    print(addressString)
//                    self.mapView.selectedMarker = self.marker
                }
        })
        
    }

    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return infoWindowView
    }

    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        
        SharedVariables.sharedInstance.addressDict = addressDict
        self.navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:- SearchBar Delegates
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        
        
        present(autocompleteController, animated: false, completion: nil)
        
        return false
    }


    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        dismiss(animated: true, completion: nil)
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        showMap(place:place)
        
        var addressDict = [String:String]()
        
        // Get the address components.
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    addressDict["street_number"] = field.name
                case kGMSPlaceTypeRoute:
                    addressDict["route"] = field.name
                case kGMSPlaceTypeNeighborhood:
                    addressDict["neighborhood"] = field.name
                case kGMSPlaceTypeLocality:
                    addressDict["locality"] = field.name
                    cityNameLabel.text = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    addressDict["administrative_area_level_1"] = field.name
                    addressLabel.text = field.name
                case kGMSPlaceTypeCountry:
                    addressDict["country"] = field.name
                case kGMSPlaceTypePostalCode:
                    addressDict["postal_code"] = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    addressDict["postal_code_suffix"] = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
            
            
        }
        
        
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: false, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
