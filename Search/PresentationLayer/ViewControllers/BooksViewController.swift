//
//  ViewController.swift
//  Search
//
//  Created by Amaduddin Ayub on 8/8/21.
//

import UIKit

fileprivate let noResultsCellIdentifier = "no_results_found"

class BooksViewController: UIViewController {

    @IBOutlet private var booksSearchBar: UISearchBar!
    @IBOutlet private var booksTableView: UITableView!
    @IBOutlet private var loadingView: UIView!

    private var searchResults = [Book]()
    private var showNoResultsFound = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Books"

        // Register tableview cells
        let bookCellNib = UINib(nibName: String(describing: BookTableViewCell.self), bundle: .main)
        booksTableView.register(bookCellNib, forCellReuseIdentifier: String(describing: BookTableViewCell.self))
    }

    private func searchBooksWithTitle(_ title: String) {
        loadingView.isHidden = false
        // requests in background and returns on main thread
        NetworkService.searchBookTitle(title) { [weak self] (books: [Book]?, error: Error?) in
            guard let books = books, error == nil else {
                self?.showNetworkError()
                return
            }

            if books.count == 0 {
                self?.showNoResultsFound = true
            }
            self?.searchResults = books
            self?.booksTableView.reloadData()
            self?.loadingView.isHidden = true
        }
    }

    private func showNetworkError() {
        loadingView.isHidden = true
        let controller = UIAlertController.init(title: "Error", message: "Request failed. Please try agian.", preferredStyle: .alert)
        controller.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))

        present(controller, animated: true)
    }
}

extension BooksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112.0
    }
}

extension BooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showNoResultsFound ? 1 : searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showNoResultsFound {
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: noResultsCellIdentifier)
            cell.textLabel?.text = "No results found"
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none

            return cell
        }

        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookTableViewCell.self)) as? BookTableViewCell {
            let book = searchResults[indexPath.row]
            cell.book = book

            return cell
        }

        return UITableViewCell()
    }
}

extension BooksViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        showNoResultsFound = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchResults.removeAll()
        booksTableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        if let title = searchBar.text {
            searchBooksWithTitle(title)
        }
    }
}
