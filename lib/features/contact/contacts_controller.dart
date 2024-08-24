import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/common/models/current_user_provider.dart';
import 'package:ult_whatsapp/common/models/user_model.dart';
import 'package:ult_whatsapp/features/contact/contact_repository.dart';
import 'package:ult_whatsapp/features/contact/contacts_notifier.dart';

// StateNotifierProvider for ContactsNotifier
final contactsControllerProvider = StateNotifierProvider<ContactsNotifier, AsyncValue<List<List<UserModel>>>>(
  (ref) {
    final contactsRepository = ref.watch(contactsRepositoryProvider);
    final currentUserAsyncValue = ref.watch(currentUserProvider);

    // Await the current user and handle different states
    final currentUser = currentUserAsyncValue.asData?.value ?? UserModel(
      username: '', 
      uid: '',
      profileImageUrl: '',
      active: false,
      lastSeen: 0,
      phoneNumber: '',
      groupId: [],
    );

    return ContactsNotifier(contactsRepository, currentUser);
  },
);
