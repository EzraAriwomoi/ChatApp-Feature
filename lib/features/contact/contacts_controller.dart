import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/common/models/current_user_provider.dart';
import 'package:ult_whatsapp/common/models/user_model.dart';
import 'package:ult_whatsapp/features/contact/contact_repository.dart';

final contactsControllerProvider = FutureProvider<List<List<UserModel>>>((ref) async {
  final contactsRepository = ref.watch(contactsRepositoryProvider);
  
  // Fetch the current user
  final currentUserAsyncValue = ref.watch(currentUserProvider);

  // Await the current user and handle different states
  final currentUser = currentUserAsyncValue.when(
    data: (user) => user,
    loading: () => Future.error('Loading current user...'),
    error: (error, stackTrace) => Future.error(error),
  ) as UserModel;

  // Fetch all contacts, excluding the current user
  return contactsRepository.getAllContacts(currentUser);
});
