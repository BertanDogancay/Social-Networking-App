import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_chat_app/common/widgets/error.dart';
import 'package:private_chat_app/common/widgets/loader.dart';
import 'package:private_chat_app/features/select_contacts/controller/select_contact_controller.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactGroup extends ConsumerStatefulWidget {
  const SelectContactGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectContactGroup> createState() => _SelectContactGroupState();
}

class _SelectContactGroupState extends ConsumerState<SelectContactGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.state)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
        data: (contactList) => Expanded(
              child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  final contact = contactList[index];
                  return InkWell(
                    onTap: () => selectContact(index, contact),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                          title: Text(
                            contact.displayName,
                            style: const TextStyle(fontSize: 18),
                          ),
                          leading: selectedContactsIndex.contains(index)
                              ? IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.done))
                              : null),
                    ),
                  );
                },
              ),
            ),
        error: (err, trace) => ErrorScreen(error: err.toString()),
        loading: () => const Loader());
  }
}
