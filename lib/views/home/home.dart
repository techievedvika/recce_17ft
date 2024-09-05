import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recce/components/custom_appbar.dart';
import 'package:recce/blocs/form_cubit.dart';
import 'package:recce/configs/color/color.dart';
import 'package:recce/configs/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FormCubit()..loadForm(),
      child: Scaffold(
        appBar: const CustomAppbar(title: 'Home Screen'),
        body: BlocConsumer<FormCubit, FormStates>(
          listener: (context, state) {
            if (state is FormError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}'),backgroundColor: AppColors.primary,),
              );
             
            }
          },
          builder: (context, state) {
            if (state is FormLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FormLoaded) {
              return ListViewWidget(
                formJsonList: state.formData,
                currentPosition: state.position,
              );
            } else if (state is FormError) {
              return 
                  Center(child: Text(state.message));
              
            }
            return const Center(child: Text('Please wait...',style: TextStyle(color: AppColors.primary,fontSize: 16,fontWeight: FontWeight.bold),));
          },
        ),
      floatingActionButton: FloatingActionButton(onPressed: (){
 _logout();
      },
      child: const Text('Logout'),
      ),
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



// Future<void> _logout(BuildContext context) async {
//   print('logout is called');
  
//   final prefs = await SharedPreferences.getInstance();
  
//   // Debug print to verify current preferences
//   print('Current isLoggedIn value before clear: ${prefs.getBool('isLoggedIn')}');
  
//   // Clear all saved preferences
//   await prefs.clear();
  
//   // Debug print to verify preferences are cleared
//   print('isLoggedIn value after clear: ${prefs.getBool('isLoggedIn')}');
  
//   // Ensure navigation happens only if context is mounted
//   if (context.mounted) {
//     Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
//   } else {
//     print('Context is not mounted. Navigation aborted.');
//   }
// }

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
    print('list view widget is called');

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
            final collectionJson = formItem['collection'] as Map<dynamic, dynamic>;

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
