import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recce/components/custom_appbar.dart';
import 'package:recce/blocs/form_cubit.dart';
import 'package:recce/blocs/network_cubit.dart'; // Import NetworkCubit
import 'package:recce/configs/color/color.dart';
import 'package:recce/configs/routes/routes_name.dart';
import 'package:recce/views/widgets/nointernet_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NetworkCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Home Screen'),
      body: BlocConsumer<NetworkCubit, NetworkState>(
        listener: (context, networkState) {
          if (networkState is NetworkDisconnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No Internet Connection'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, networkState) {
          if (networkState is NetworkConnected) {
            return BlocConsumer<FormCubit, FormStates>(
              listener: (context, formState) {
                if (formState is FormError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${formState.message}'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                }
              },
              builder: (context, formState) {
                if (formState is FormLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (formState is FormLoaded) {
                  return ListViewWidget(
                    formJsonList: formState.formData,
                    currentPosition: formState.position,
                  );
                } else if (formState is FormError) {
                  return Center(child: Text(formState.message));
                }
                return const Center(
                    child: Text(
                  'Please wait...',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ));
              },
            );
          } else if (networkState is NetworkDisconnected) {
            return NoInternetWidget(
              onRetry: () {
                context.read<NetworkCubit>();
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _logout();
        },
        child: const Text('Logout'),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Correctly clear the login state
    print('Current isLoggedIn value before clear: ${prefs.getBool('isLoggedIn')}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
    });
  }
}

class ListViewWidget extends StatelessWidget {
  final List<Map<String, dynamic>> formJsonList;
  final Position? currentPosition;

  const ListViewWidget({
    super.key,
    required this.formJsonList,
    required this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FormCubit>().loadForm();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: formJsonList.length,
          itemBuilder: (context, index) {
            final formItem = formJsonList[index];
            final formName = formItem['name'] as String;
            final formId = formItem['id'] as int;
            final collectionJson =
                formItem['collection'] as Map<dynamic, dynamic>;

            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  formName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text('No Description'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/form1_screen',
                    arguments: {
                      'formName': formName,
                      'collectionJson': collectionJson,
                      'position': currentPosition,
                      'id': formId.toString(),
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}