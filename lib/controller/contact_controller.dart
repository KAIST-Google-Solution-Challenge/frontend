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
    print("(getName) func called, number : $number");
    for (Contact contact in contacts) {
      for (Item phone in contact.phones!) {
        if (phone.value!.replaceAll(RegExp('[^0-9]'), '') ==
            number.replaceAll(RegExp('[^0-9]'), '')) {
          print("(getName) an registered number!, name : ${contact.displayName}");
          return contact.displayName!;
        }
      }
    }
    print("(getName) NOT registered number, number : $number");

    return number;
  }
}
