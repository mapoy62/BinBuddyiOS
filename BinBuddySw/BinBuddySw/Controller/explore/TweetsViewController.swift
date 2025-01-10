//
//  TweetsViewController.swift
//  BinBuddySw
//
//  Created by OYuuyuMP on 08/01/25.
//

import UIKit

class TweetsViewController: UIViewController, UICollectionViewDataSource
                                //UITableViewDataSource,UITableViewDelegate
{    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as! TweetCollectionViewCell
                let tweet = tweets[indexPath.item]

                // Configurar la celda
                cell.configure(with: tweet, image: nil) // Aquí puedes agregar lógica para cargar imágenes si es necesario

                return cell
    }
    
    private var tweets: [Tweet] = [] // Array de tweets
        private let twitterService = TwitterService() // Servicio para la API de Twitter

        override func viewDidLoad() {
            super.viewDidLoad()

            // Configurar la tabla
            collectionView.dataSource = self
            collectionView.delegate = self

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
    
    /*

        // MARK: - UITableViewDataSource
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tweets.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath)
            let tweet = tweets[indexPath.row]

            // Configurar la celda
            //cell.textLabel?.text = tweet.author // Autor del tweet
            cell.detailTextLabel?.text = tweet.text // Texto del tweet

            return cell
        }
     */

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
             /*
            self.tweets = [
                    Tweet(id: "1877513938138472927", text: "RT @Alecus62: #mineria #Alecus #Medioambiente https://t.co/9DnKI3YY3C"),
                    Tweet(id: "1877513424910848490", text: "🌍❄️ ¡2025, el Año Internacional de la Conservación de los #Glaciares! ❄️🌍"),
                    Tweet(id: "1877513380224708885", text: "#MedioAmbiente Uruguay 🇺🇾 #Rocha 👇🏾 https://t.co/LBWl87UbGZ")
                ]
                self.tableView.reloadData()
              */
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
