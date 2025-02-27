import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:requirment_gathering_app/dashboard/home/company_list_page.dart';
import 'package:requirment_gathering_app/dashboard/home/dashboard_cubit.dart';
import 'package:requirment_gathering_app/dashboard/reports_page.dart';
import 'package:requirment_gathering_app/dashboard/settings_page.dart';
import 'package:requirment_gathering_app/service_locator/service_locator.dart';
import 'package:requirment_gathering_app/dashboard/home/home_page.dart';
import 'package:requirment_gathering_app/widget/custom_appbar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardCubit>(),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Dashboard",
        ),
        body: BlocBuilder<DashboardCubit, int>(
          builder: (context, state) {
            final pages = [
              const HomePage(),
               CompanyListPage(),
              const ReportsPage(),
              const CompanySettingPage(),
            ];
            return pages[state];
          },
        ),
        bottomNavigationBar: BlocBuilder<DashboardCubit, int>(
          builder: (context, state) {
            return BottomNavigationBar(
              backgroundColor: Colors.lightBlue,
              selectedItemColor: Colors.blue, // White for active items
              unselectedItemColor: Colors.grey, // Semi-transparent for inactive items
              currentIndex: state,
              onTap: (index) => context.read<DashboardCubit>().updateIndex(index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Companies',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: 'Reports',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
