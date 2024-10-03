import 'package:devpy_permission_handler/devpy_permission_handler.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PermissionHandlerWeb(),
  ));
}

class PermissionHandlerWeb extends StatefulWidget {
  const PermissionHandlerWeb({super.key});

  @override
  State<PermissionHandlerWeb> createState() => _PermissionHandlerWebState();
}

class _PermissionHandlerWebState extends State<PermissionHandlerWeb> {
  final _permissionHandler = const PermissionHandlerService();

  String permissionName = '';
  AppPermissionStatus status = AppPermissionStatus.denied;

  void getPermission(BuildContext context) async {
    final perm =
        await _permissionHandler.checkPermission(AppPermissions.location);

    if (status == AppPermissionStatus.granted) {
      permissionIsGranted(AppPermissions.location);
      return;
    }

    setState(() {
      permissionName = perm.name;
      status = perm;
    });
  }

  void permissionIsGranted(AppPermissions perm) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$perm status is $status'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Okay',
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar,
        ),
      ),
    );
  }

  Color getBackgroudColor(AppPermissionStatus status) {
    return switch (status) {
      AppPermissionStatus.granted => Colors.green,
      AppPermissionStatus.permanentlyDenied => Colors.red,
      AppPermissionStatus.denied => Colors.yellow,
      _ => Colors.orange,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroudColor(status),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Is Web: ${Platform.isWeb}'),
            Text(permissionName),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_on),
        onPressed: () => getPermission(context),
      ),
    );
  }
}
