import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/common/models/current_user_provider.dart';
import 'package:ult_whatsapp/common/models/user_model.dart';
import 'package:ult_whatsapp/features/contact/contact_repository.dart';

class ContactsNotifier extends StateNotifier<AsyncValue<List<List<UserModel>>>> {
  final ContactsRepository _contactsRepository;
  final UserModel _currentUser;

  ContactsNotifier(this._contactsRepository, this._currentUser)
      : super(const AsyncValue.loading()) {
    _fetchAndCheckContacts();
  }

  // Fetch contacts and update state
  Future<void> _fetchAndCheckContacts() async {
    try {
      final contacts = await _contactsRepository.getAllContacts(_currentUser);
      state = AsyncValue.data(contacts);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Refresh contacts
  Future<void> refreshContacts() async {
    state = const AsyncValue.loading();
    await _fetchAndCheckContacts();
  }
}

// Provider for ContactsNotifier
final contactsControllerProvider = StateNotifierProvider<ContactsNotifier, AsyncValue<List<List<UserModel>>>>(
  (ref) {
    final contactsRepository = ref.watch(contactsRepositoryProvider);
    final currentUser = ref.watch(currentUserProvider).asData?.value ?? UserModel(
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
