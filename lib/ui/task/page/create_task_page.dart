import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/app/utils/validation.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/redux/task/actions.dart';
import 'package:ayeayecaptain_mobile/ui/components/custom_filled_button.dart';
import 'package:ayeayecaptain_mobile/ui/components/custom_text_field.dart';
import 'package:ayeayecaptain_mobile/ui/components/unfocusable.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

final _formKey = GlobalKey<FormState>();
const _queuePositionTop = 'top';
const _queuePositionBottom = 'bottom';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final store = di<Store<AppState>>();
  String title = '';
  bool addToUserQueue = false;
  String queuePosition = _queuePositionTop;

  void switchAddToUserQueue() {
    setState(() {
      addToUserQueue = !addToUserQueue;
    });
  }

  void onQueuePositionChanged(String? value) {
    setState(() {
      queuePosition = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Unfocusable(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Task'),
          centerTitle: true,
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
                    label: 'Title',
                    validator: isNotEmptyValidator,
                    autocorrect: false,
                    onChanged: (value) => title = value.trim(),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: addToUserQueue,
                        onChanged: (value) => switchAddToUserQueue(),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => switchAddToUserQueue(),
                        child: const Text('Add to my queue'),
                      ),
                    ],
                  ),
                  if (addToUserQueue)
                    Column(
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: _queuePositionTop,
                              groupValue: queuePosition,
                              onChanged: onQueuePositionChanged,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  onQueuePositionChanged(_queuePositionTop),
                              child: const Text('Add to the top'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: _queuePositionBottom,
                              groupValue: queuePosition,
                              onChanged: onQueuePositionChanged,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  onQueuePositionChanged(_queuePositionBottom),
                              child: const Text('Add to the bottom'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  CustomFilledButton(
                    title: 'Create',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        store.dispatch(CreateTaskAction(
                          title: title,
                          addToUserQueue: addToUserQueue,
                          queuePosition: queuePosition,
                        ));
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
