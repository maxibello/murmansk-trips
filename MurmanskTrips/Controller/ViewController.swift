//
//  ViewController.swift
//  MurmanskTrips
//
//  Created by Maxim Kuznetsov on 21.11.2020.
//

import UIKit

class ViewController: UIViewController {
    
    var trips: [Trip] = []
    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                             left: 20.0,
                                             bottom: 30.0,
                                             right: 20.0)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        title = "Маршруты"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "setting"), for: .normal)
        
        rightButton.setTitleColor(.purple, for: .normal)
        navigationController?.navigationBar.addSubview(rightButton)
        let targetView = self.navigationController?.navigationBar
        let trailingContraint = NSLayoutConstraint(item: rightButton, attribute:
                                                    .trailingMargin, relatedBy: .equal, toItem: targetView,
                                                   attribute: .trailingMargin, multiplier: 1.0, constant: -30)
        bottomConstraint = NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal,
                                                  toItem: targetView, attribute: .bottom, multiplier: 1.0, constant: -15)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([trailingContraint, bottomConstraint])
        
        loadData()
    }
    
    private func loadData() {
        activityIndicator.startAnimating()
        TravelAPI.loadData { [weak self] result in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            switch result {
            case .success(let trips):
                self.trips = trips.data
                self.collectionView.reloadData()
            case .failure( _):
                let alert = UIAlertController(title: "Ошибка", message: "Произошла сетевая ошибка", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Попробовать снова", style: .default, handler: {[weak self] _ in self?.loadData() }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripCell", for: indexPath) as! TripViewCell
        cell.configure(with: trips[indexPath.row])
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left + sectionInsets.right
        let sideWidth = view.bounds.width - paddingSpace
        return CGSize(width: sideWidth, height: sideWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let height = navigationController?.navigationBar.frame.size.height, height == 44 {
            if bottomConstraint.constant != -10 {
                bottomConstraint.constant = -10
            }
        }
        else {
            if bottomConstraint.constant != -15 {
                bottomConstraint.constant = -15
            }
        }
    }
    
}
