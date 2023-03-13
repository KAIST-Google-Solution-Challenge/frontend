import 'package:contacts_service/contacts_service.dart';

class ContactController {
  late List<Contact> contacts;

  Future<void> init() async {
    contacts = await ContactsService.getContacts();
  }

  String getName(String number) {
    for (Contact contact in contacts) {
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
