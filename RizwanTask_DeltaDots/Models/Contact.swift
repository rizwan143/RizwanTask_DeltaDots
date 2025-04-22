// Model for contact
import UIKit


struct Contact: Equatable {
    let id: UUID = UUID()
    let name: String
    let image: UIImage?

    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.id == rhs.id
    }
}


class ContactsViewModel {
    let allContacts: [Contact]
    var filteredContacts: [Contact]
    var selectedContacts: [Contact]
    
    init() {
        allContacts = (0..<20).map { _ in
            Contact(name: "Michelle Jones", image: UIImage(named: "contactPlaceholdersmall"))
        }
        filteredContacts = allContacts
        selectedContacts = []
    }
    
    func filterContacts(_ searchText: String) {
        if searchText.isEmpty {
            filteredContacts = allContacts
        } else {
            filteredContacts = allContacts.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func toggleSelection(for contact: Contact) {
        if isSelected(contact) {
            selectedContacts.removeAll { $0 == contact }
        } else {
            selectedContacts.append(contact)
        }
    }

    func isSelected(_ contact: Contact) -> Bool {
        return selectedContacts.contains(contact)
    }
}
