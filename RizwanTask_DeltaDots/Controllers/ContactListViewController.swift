
import UIKit

protocol ContactsSelectionDelegate: AnyObject {
    func didSelectContacts(_ contacts: [Contact])
}

class ContactsViewController: UIViewController {
    
    private var viewModel: ContactsViewModel!
    weak var delegate: ContactsSelectionDelegate?
    var selectedContacts: [Contact] = []
    private let contentView = ContactListView()
    
    //MARK: - Load ViewFile
    override func loadView() {
        super.loadView()
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            viewModel = ContactsViewModel()
        }
        setupNecessaryDelegates()
        setupNavigation()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.selectedContacts = viewModel.allContacts.filter { contact in
            selectedContacts.contains(where: { $0.id == contact.id })
        }
        contentView.contactsTV.reloadData()
    }
    
    private func setupNecessaryDelegates() {
        contentView.contactSearchBar.delegate = self
        contentView.contactsTV.dataSource = self
        contentView.contactsTV.delegate = self
    }
    
    private func setupNavigation() {
        title = "Contacts"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneTapped() {
        delegate?.didSelectContacts(viewModel.selectedContacts)
        dismiss(animated: true)
    }
}

// MARK: - TableView
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = viewModel.filteredContacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactListCell", for: indexPath)
        cell.textLabel?.text = contact.name
        cell.imageView?.image = contact.image
        cell.accessoryType = viewModel.isSelected(contact) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = viewModel.filteredContacts[indexPath.row]
        viewModel.toggleSelection(for: contact)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
}

// MARK: - SearchBar
extension ContactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterContacts(searchText)
        contentView.contactsTV.reloadData()
    }
}


