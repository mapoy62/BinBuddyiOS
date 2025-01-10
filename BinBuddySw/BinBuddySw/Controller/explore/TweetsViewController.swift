//
//  TweetsViewController.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 08/01/25.
//

import UIKit
import MapKit

class TweetsViewController: UIViewController, UICollectionViewDataSource
                                //UITableViewDataSource,UITableViewDelegate
{    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var instagramCollectionView: UICollectionView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var instagramProfiles: [InstagramProfile] = []
    private let instagramService = InstagramService()
    
    private var recyclingEvents: [RecyclingEvent] = []
    private let recyclingEventService = RecyclingEventService()

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == instagramCollectionView {
                    return instagramProfiles.count
                } else {
                    return tweets.count
                }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == instagramCollectionView {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstagramProfileCell", for: indexPath) as! InstagramProfileCollectionViewCell
                    let profile = instagramProfiles[indexPath.item]
                    cell.configure(with: profile)
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as! TweetCollectionViewCell
                    let tweet = tweets[indexPath.item]
                    cell.configure(with: tweet, image: nil)
                    return cell
                }
    }
    
    private var tweets: [Tweet] = [] // Array de tweets
    private let twitterService = TwitterService() // Servicio para la API de Twitter

        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Configuración del Collection View para los perfiles
            instagramCollectionView.dataSource = self
            instagramCollectionView.delegate = self

            // Configurar la tabla de tweets
            collectionView.dataSource = self
            collectionView.delegate = self
            
            //Configuración del MapView
            mapView.delegate = self
            
            
            fetchInstagramProfiles()
            fetchRecyclingEvents()

            if let cachedTweets = loadTweetsFromLocalStorage() {
                    // Usando los tweets almacenados
                    self.tweets = cachedTweets
                self.collectionView.reloadData()
                    print("Cargando tweets desde almacenamiento local")
                } else {
                    // Consulta nuevos tweets si no hay datos locales o es un nuevo día
                    fetchTweets()
                }
        }
    

    private func fetchInstagramProfiles() {
        instagramService.fetchInstagramProfiles { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profiles):
                    self?.instagramProfiles = profiles
                    self?.instagramCollectionView.reloadData()
                case .failure(let error):
                    print("Error al obtener perfiles de Instagram: \(error.localizedDescription)")
                }
            }
        }
    }

        
    // MARK: - Fetch Tweets
        private func fetchTweets() {
            
            twitterService.fetchTweets(with: "MedioAmbiente", maxResults: 10) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let tweets):
                        if tweets.isEmpty {
                            print("No se encontraron tweets.")
                        } else {
                            self?.tweets = tweets
                            self?.collectionView.reloadData()
                            self?.saveTweetsToLocalStorage(tweets)
                        }
                    case .failure(let error):
                        print("Error al obtener tweets: \(error.localizedDescription)")
                        self?.showError(error.localizedDescription)
                    }
                }
            }
        }

        private func showError(_ message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    
        private func saveTweetsToLocalStorage(_ tweets: [Tweet]) {
            let encoder = JSONEncoder()
            let currentDate = Date()

            do {
                let encodedTweets = try encoder.encode(tweets)
                UserDefaults.standard.set(encodedTweets, forKey: "cachedTweets")
                UserDefaults.standard.set(currentDate, forKey: "lastFetchDate")
            } catch {
                print("Error al guardar tweets localmente: \(error.localizedDescription)")
            }
        }
    
        private func loadTweetsFromLocalStorage() -> [Tweet]? {
            let decoder = JSONDecoder()

            guard let savedData = UserDefaults.standard.data(forKey: "cachedTweets"),
                  let savedDate = UserDefaults.standard.object(forKey: "lastFetchDate") as? Date else {
                return nil
            }

            let calendar = Calendar.current
            if calendar.isDateInToday(savedDate) {
                do {
                    let tweets = try decoder.decode([Tweet].self, from: savedData)
                    return tweets
                } catch {
                    print("Error al decodificar tweets: \(error.localizedDescription)")
                }
            }

            return nil
    }

    
    private func fetchRecyclingEvents() {
        recyclingEventService.fetchRecyclingEvents { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    self?.recyclingEvents = events
                    self?.addEventsToMap()

                    // Encontrar el evento más próximo y centrar el mapa
                    if let nextEvent = self?.getNextEvent() {
                        self?.centerMapOnEvent(nextEvent)
                    }
                case .failure(let error):
                    print(self?.recyclingEvents)
                    self?.showError(error.localizedDescription)
                    print("Error al obtener eventos de reciclaje: \(error.localizedDescription)")
                }
            }
        }
    }

    
    private func addEventsToMap() {
        for event in recyclingEvents {
            let annotation = MKPointAnnotation()
            annotation.title = event.name
            annotation.subtitle = "\(event.points) puntos - \(event.description)"
            annotation.coordinate = CLLocationCoordinate2D(latitude: event.locationLat, longitude: event.locationLong)
            mapView.addAnnotation(annotation)
        }
    }

    private func getNextEvent() -> RecyclingEvent? {
        let currentDate = Date()

        // Filtrar eventos futuros y encontrar el más próximo
        return recyclingEvents
            .filter { $0.eventDate ?? Date.distantPast >= currentDate }
            .min(by: { ($0.eventDate ?? Date.distantFuture) < ($1.eventDate ?? Date.distantFuture) })
    }

    private func centerMapOnEvent(_ event: RecyclingEvent) {
        let coordinate = CLLocationCoordinate2D(latitude: event.locationLat, longitude: event.locationLong)

        // Configurar el rango de zoom
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 5000, // Rango en metros
            longitudinalMeters: 5000
        )
        mapView.setRegion(region, animated: true)
    }

}


extension TweetsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Ancho de la celda = 80% del ancho del UICollectionView
        let width = collectionView.frame.width * 0.8
        let height = collectionView.frame.height * 0.9
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16 // Espaciado entre las celdas
    }
}

extension TweetsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == instagramCollectionView {
            let profile = instagramProfiles[indexPath.item]
            if let url = URL(string: profile.urlPage) {
                UIApplication.shared.open(url)
            }
        }
    }
}

extension TweetsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "RecyclingEventPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.glyphTintColor = .green

            // Botón de acción para abrir más detalles
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else { return }

        // Buscar el evento correspondiente
        if let event = recyclingEvents.first(where: { $0.name == annotation.title }) {
            print("Evento seleccionado: \(event.name)")
            // Aquí puedes abrir una nueva vista o mostrar un modal con más detalles
        }
    }
}


