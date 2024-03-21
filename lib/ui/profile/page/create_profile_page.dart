import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/app/utils/validation.dart';
import 'package:ayeayecaptain_mobile/domain/profile/entity/profile.dart';
import 'package:ayeayecaptain_mobile/redux/app/actions.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/ui/components/custom_filled_button.dart';
import 'package:ayeayecaptain_mobile/ui/components/custom_text_field.dart';
import 'package:ayeayecaptain_mobile/ui/components/unfocusable.dart';
import 'package:ayeayecaptain_mobile/ui/dialog/page/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

final _formKey = GlobalKey<FormState>();

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final store = di<Store<AppState>>();
  String backendUrl = '';
  String name = '';
  String password = '';

  void _addProfile(Profile newProfile) {
    final profiles = List<Profile>.from(store.state.profiles ?? [])
        .map((e) => e.copyWith(isSelected: false))
        .toList();
    store.dispatch(SaveProfilesAction([...profiles, newProfile]));
  }

  bool profileExists() {
    return store.state.profiles
            ?.any((e) => e.name == name && e.backendUrl == backendUrl) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Unfocusable(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Profile'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => store.dispatch(ClosePageAction()),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextField(
                    label: 'Backend URL',
                    validator: isNotEmptyValidator,
                    onChanged: (value) {
                      backendUrl = value.trim();
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Name',
                    validator: isNotEmptyValidator,
                    onChanged: (value) {
                      name = value.trim();
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Password',
                    validator: isNotEmptyValidator,
                    obscureText: true,
                    onChanged: (value) {
                      password = value.trim();
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomFilledButton(
                    title: 'Create',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (!profileExists()) {
                          _addProfile(Profile(
                            backendUrl: backendUrl,
                            name: name,
                            password: password,
                            token: '123',
                            isSelected: true,
                          ));
                          store.dispatch(ClosePageAction());
                        } else {
                          store.dispatch(
                            OpenAlertDialogAction(
                              DialogConfig(
                                content:
                                    'A profile with the same name and backend URL already exists.',
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
