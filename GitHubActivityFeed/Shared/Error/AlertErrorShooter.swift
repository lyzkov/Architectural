//
//  AlertErrorShooter.swift
//  GitHubActivityFeed
//
//  Created by BOGU$ on 09/07/2019.
//  Copyright © 2019 lyzkov. All rights reserved.
//

import UIKit
import SinkEmAll

protocol AlertError: RetriableError {
    var description: String { get }
}

final class AlertErrorShooter: ErrorShooting {

    private unowned var presenter: UIViewController!

    init(presenter: UIViewController) {
        self.presenter = presenter
    }

    func shoot(error: AlertError, attempt: Int, complete: @escaping (Shot) -> Void) {
        let alert = UIAlertController(title: "Error ocurred", message: error.description, preferredStyle: .alert)
        if error.canRetry && attempt < 3 {
            alert.addAction(
                UIAlertAction(title: "Retry", style: .cancel) { _ in
                    complete(.miss)
                }
            )
        }
        alert.addAction(
            UIAlertAction(title: "Close", style: .destructive) { _ in
                complete(.sink)
            }
        )

        presenter.present(alert, animated: true)
    }

}
