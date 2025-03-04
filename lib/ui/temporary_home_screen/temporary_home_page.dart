import 'dart:async';

import 'package:ayeayecaptain_mobile/app/globals.dart';
import 'package:ayeayecaptain_mobile/redux/app/app_state.dart';
import 'package:ayeayecaptain_mobile/redux/navigation/actions.dart';
import 'package:ayeayecaptain_mobile/ui/temporary_home_screen/controller/temporary_home_page_cubit.dart';
import 'package:ayeayecaptain_mobile/ui/temporary_home_screen/controller/temporary_home_page_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TemporaryHomePage extends StatelessWidget {
  const TemporaryHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TemporaryHomePageCubit(),
      child: TemporaryHomePageView(),
    );
  }
}

class TemporaryHomePageView extends StatefulWidget {
  const TemporaryHomePageView({super.key});

  @override
  State<TemporaryHomePageView> createState() => _TemporaryHomePageViewState();
}

class _TemporaryHomePageViewState extends State<TemporaryHomePageView> {
  final store = di<Store<AppState>>();
  late final Timer timer;

  void showToaster() {
    Fluttertoast.showToast(
      msg: "Got it",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xFF83D481),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    final cubit = context.read<TemporaryHomePageCubit>();
    timer = Timer.periodic(Duration(seconds: 5), (_) {
      cubit.fetchHomePage();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<TemporaryHomePageCubit, TemporaryHomePageStates>(
          buildWhen: (previous, current) => current is FetchHomePageState,
          builder: (context, state) {
            if (state is FetchHomePageState) {
              return state.status == StateStatus.success
                  ? state.response['beacon'] == null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (state.response['message'] != null)
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                color: Color(0xFFF1A253),
                                child: Text(
                                  state.response['message'] ?? "",
                                  textAlign: TextAlign.center,
                                  maxLines: null,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (state.response['currently_working_on'] == null) ...[
                              SizedBox(height: 5),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                color: Color(0xFFE557BD),
                                child: Text(
                                  "Time is not being logged",
                                  textAlign: TextAlign.center,
                                  maxLines: null,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            if (state.response['currently_working_on'] != null) ...[
                              SizedBox(height: 20),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                color: Color(0xFF83D481),
                                child: Text(
                                  state.response['currently_working_on']['title'],
                                  textAlign: TextAlign.center,
                                  maxLines: null,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                            Expanded(
                              child: Center(
                                child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (BuildContext context, int index) {
                                    return TextButton(
                                      onPressed: () async {
                                        showToaster();
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xFFFCEEC2),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                      ),
                                      child: Text(
                                        state.response['instant_actions'][index]['label'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (BuildContext context, int index) {
                                    return SizedBox(height: 40);
                                  },
                                  itemCount: state.response['instant_actions'].length,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: InkWell(
                                onTap: () async {
                                  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                                  final storage = FlutterSecureStorage();
                                  timer.cancel();
                                  await sharedPreferences.clear();
                                  await storage.deleteAll();
                                  store.dispatch(OpenCreateProfilePageAction());
                                },
                                child: Text(
                                  "Logout",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                              onPressed: () async {
                                final cubit = context.read<TemporaryHomePageCubit>();
                                await cubit.clickMeAction(id: state.response['beacon']['id']);
                                showToaster();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xFF83D481),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              ),
                              child: Text(
                                "Click me",
                                textAlign: TextAlign.center,
                                maxLines: null,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                  : Center(child: const CupertinoActivityIndicator());
            }
            return Center(child: const CupertinoActivityIndicator());
          },
        ),
      ),
    );
  }
}
