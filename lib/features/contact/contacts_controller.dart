import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/features/contact/contact_repository.dart';

final contactsControllerProvider = FutureProvider(
  (ref) {
    final contactsRepository = ref.watch(contactsRepositoryProvider);
    return contactsRepository.getAllContacts();
  },
);