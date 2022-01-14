//
//  ViewController.swift
//  URLSession
//
//  Created by 김효성 on 2022/01/14.
//

import UIKit

final class ViewController: UIViewController {
    
    private let photosRepository: PhotosRepositoryProtocol = PhotosRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
        let data = photosRepository.get(page: 1,
                                        perPage: 10,
                                        orderBy: .latest)
        try await print(data.value)
        }
    }
}
