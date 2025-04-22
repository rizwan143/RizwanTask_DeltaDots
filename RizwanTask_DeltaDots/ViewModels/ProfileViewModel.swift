// ViewModel for Profile
import UIKit
class ProfileViewModel {
    var name: String = ""
    var profileImage: UIImage?
    var coverVideoURL: URL?
    var selectedContacts: [Contact] = []
    var latitude: Double?
    var longitude: Double?
}
