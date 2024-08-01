//
//  ImagesListViewController.swift
//  Pictorium
//
//  Created by Simon Butenko on 02.03.2024.
//
import UIKit

enum ImagesListViewControllerFactory {
    static func makeController() -> ImagesListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController") as! ImagesListViewController

        let imagesListService = ImagesListService.shared
        let presenter = ImagesListPresenter(service: imagesListService)

        viewController.presenter = presenter
        presenter.view = viewController

        return viewController
    }
}

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated()
    func displayShimmerEffect()
    func hideShimmerEffect()
    func showTableView()
    func configureTableView()
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    // MARK: - Constants

    private let showSingleImageSegueIdentifier = "ShowSingleImage"

    // MARK: - IBOutlets

    @IBOutlet var tableView: UITableView!
    @IBOutlet var shimmerContainerView: UIView!

    // MARK: - Public Properties

    var presenter: ImagesListPresenterProtocol?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        presenter?.viewDidLoad()
    }

    // MARK: - ImagesListViewControllerProtocol

    func updateTableViewAnimated() {
        tableView.performBatchUpdates {
            let oldCount = tableView.numberOfRows(inSection: 0)
            let newCount = presenter?.photos.count ?? 0

            if oldCount < newCount {
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } else if oldCount > newCount {
                let indexPaths = (newCount..<oldCount).map { IndexPath(row: $0, section: 0) }
                tableView.deleteRows(at: indexPaths, with: .automatic)
            }
        }
    }

    func displayShimmerEffect() {
        let shimmerViews = createShimmerViews()
        let stackView = UIStackView(arrangedSubviews: shimmerViews)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill

        shimmerContainerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: shimmerContainerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: shimmerContainerView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: shimmerContainerView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: shimmerContainerView.bottomAnchor, constant: -16)
        ])
    }

    func hideShimmerEffect() {
        shimmerContainerView.isHidden = true
    }

    func showTableView() {
        tableView.isHidden = false
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

    // MARK: - Private Methods

    private func createShimmerViews() -> [UIView] {
        let heights: [CGFloat] = [370, 252, 230, 310, 400]

        return heights.map { height in
            let shimmerView = ShimmerView()
            shimmerView.translatesAutoresizingMaskIntoConstraints = false
            shimmerView.heightAnchor.constraint(equalToConstant: height).isActive = true
            return shimmerView
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath,
                  let photo = presenter?.photos[safe: indexPath.row]
            else {
                assertionFailure("Invalid segue destination or photo")
                return
            }
            viewController.photo = photo
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = presenter?.photos[safe: indexPath.row] else { return 0 }

        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == presenter?.photos.count {
            presenter?.fetchPhotosNextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell,
              let photo = presenter?.photos[safe: indexPath.row]
        else {
            return UITableViewCell()
        }

        imageListCell.configure(with: indexPath, show: photo)
        return imageListCell
    }
}
