import 'package:contacts_service/contacts_service.dart';

class ContactController {
  static String getName(List<Contact> contacts, String number) {
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
