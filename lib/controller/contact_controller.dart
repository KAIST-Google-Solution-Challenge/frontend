import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactController {
  late List<Contact> contacts;

  Future<void> init() async {
    var contactsStatus = await Permission.contacts.status;
    if (!contactsStatus.isGranted) {
      await Permission.contacts.request();
    }

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

    return number;
  }
}
