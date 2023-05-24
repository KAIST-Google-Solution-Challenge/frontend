import 'package:contacts_service/contacts_service.dart';

class ContactController {
  static List<Contact> _contacts = [];

  static Future<void> fetchContacts() async {
    _contacts = await ContactsService.getContacts(withThumbnails: false);
  }

  static String getName(String number) {
    for (Contact contact in _contacts) {
      for (Item phone in contact.phones!) {
        if (phone.value!.replaceAll(RegExp('[^0-9]'), '') ==
            number.replaceAll(RegExp('[^0-9]'), '')) {
          return contact.displayName!;
        }
      }
    }

    return '';
  }
}
