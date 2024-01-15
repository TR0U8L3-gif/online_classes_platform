import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:online_classes_platform/config/assets/app_colors.dart';
import 'package:online_classes_platform/core/common/providers/user_provider.dart';
import 'package:online_classes_platform/src/auth/data/models/local_user_model.dart';
import 'package:online_classes_platform/src/dashboard/providers/dashboard_controller.dart';
import 'package:online_classes_platform/src/dashboard/utils/dashboard_utils.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const routeName = '/dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalUserModel>(
        stream: DashboardUtils.userDataStream,
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data is LocalUserModel) {
            context.read<UserProvider>().user = snapshot.data;
          }
          return Consumer<DashboardController>(builder: (_, controller, __) {
            return Scaffold(
              body: IndexedStack(
                index: controller.currentIndex,
                children: controller.screens,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: controller.currentIndex,
                showSelectedLabels: false,
                backgroundColor: Colors.white,
                elevation: 8,
                onTap: controller.changeIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 0
                          ? IconlyBold.home
                          : IconlyLight.home,
                      color: controller.currentIndex == 0
                          ? AppColors.primaryColor
                          : Colors.grey,
                    ),
                    label: 'Home',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 1
                          ? IconlyBold.document
                          : IconlyLight.document,
                      color: controller.currentIndex == 1
                          ? AppColors.primaryColor
                          : Colors.grey,
                    ),
                    label: 'Materials',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 2
                          ? IconlyBold.chat
                          : IconlyLight.chat,
                      color: controller.currentIndex == 2
                          ? AppColors.primaryColor
                          : Colors.grey,
                    ),
                    label: 'Chat',
                    backgroundColor: Colors.white,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      controller.currentIndex == 3
                          ? IconlyBold.profile
                          : IconlyLight.profile,
                      color: controller.currentIndex == 3
                          ? AppColors.primaryColor
                          : Colors.grey,
                    ),
                    label: 'Profile',
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            );
          });
        });
  }
}
