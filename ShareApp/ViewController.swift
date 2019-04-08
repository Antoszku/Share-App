//
//  ViewController.swift
//  ShareApp
//
//  Created by Dominik Rygiel on 01/04/2019.
//  Copyright © 2019 Dominik Rygiel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let userDefaults = UserDefaults(suiteName: "group.DominikRygiel.share")
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var sharedFiles = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        makeConstraints()

        collectionView.backgroundColor = .clear
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCellID")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(getSharedFiles), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        let image = UIImage()
//        sharedFiles = [image, image, image]
//        collectionView.reloadData()
        getSharedFiles()
    }

    @objc private func getSharedFiles() {
        guard let arrayOfData = userDefaults?.array(forKey: "SharedImages") as? [Data] else { return }

        let arrayOfImages = arrayOfData.compactMap { UIImage(data: $0) }
        sharedFiles = arrayOfImages
        collectionView.reloadData()
    }

    private func makeConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sharedFiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellID", for: indexPath) as! ImageCell
        cell.update(with: sharedFiles[indexPath.row])
        cell.imageView.backgroundColor = .red
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2 - 6.0, height: view.frame.height / 2)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
}
