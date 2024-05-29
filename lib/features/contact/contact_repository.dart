import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ult_whatsapp/common/models/user_model.dart';

final contactsRepositoryProvider = Provider((ref) {
  return ContactsRepository(firestore: FirebaseFirestore.instance);
});

class ContactsRepository {
  final FirebaseFirestore firestore;

  ContactsRepository({required this.firestore});

  Future<List<List<UserModel>>> getAllContacts() async {
    List<UserModel> firebaseContacts = [];
    List<UserModel> phoneContacts = [];

    try {
      // Check if permission to access contacts is granted
      if (await _checkContactPermission()) {
        final userCollection = await firestore.collection('users').get();

        // Fetch all contacts in batches
        final allContactsInThePhone = await _getAllContactsInBatches();

        bool isContactFound = false;

        for (var contact in allContactsInThePhone) {
          for (var firebaseContactData in userCollection.docs) {
            var firebaseContact =
                UserModel.fromMap(firebaseContactData.data());
            if (contact.phones.isNotEmpty &&
                contact.phones[0].number.replaceAll(' ', '') ==
                    firebaseContact.phoneNumber) {
              firebaseContacts.add(firebaseContact);
              isContactFound = true;
              break;
            }
          }
          if (!isContactFound) {
            // Create UserModel instance for phone contact
            phoneContacts.add(
              UserModel(
                username: contact.displayName,
                uid: '',
                profileImageUrl: '',
                active: false,
                lastSeen: 0,
                phoneNumber: contact.phones.isNotEmpty
                    ? contact.phones[0].number.replaceAll(' ', '')
                    : '',
                groupId: [],
              ),
            );
          }

          isContactFound = false;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return [firebaseContacts, phoneContacts];
  }

  Future<bool> _checkContactPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      return true;
    } else {
      var result = await Permission.contacts.request();
      return result.isGranted;
    }
  }

  Future<List<Contact>> _getAllContactsInBatches() async {
    List<Contact> allContacts = [];

    try {
      final allContactsInThePhone = await FlutterContacts.getContacts(
        withProperties: true,
      );

      // Filter out blank contacts
      allContacts.addAll(allContactsInThePhone.where((contact) =>
          contact.displayName.isNotEmpty ||
          (contact.phones.isNotEmpty &&
              contact.phones.any((phone) => phone.number.isNotEmpty))));
    } catch (e) {
      log(e.toString());
    }

    return allContacts;
  }
}
