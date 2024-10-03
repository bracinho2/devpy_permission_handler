import 'package:permission_handler/permission_handler.dart';

import 'enums.dart';
import 'platform_checker.dart';

class PermissionHandlerService {
  const PermissionHandlerService();

  Future<AppPermissionStatus> checkPermission(
    AppPermissions permission,
  ) async {
    if (Platform.isWeb) {
      switch (permission) {
        case AppPermissions.location:
          return _getStatus(status: await Permission.location.request());
        case AppPermissions.camera:
          return _getStatus(status: await Permission.camera.request());
      }
    } else {
      switch (permission) {
        case AppPermissions.location:
          return _getMobileStatus(status: await Permission.location.request());
        case AppPermissions.camera:
          return _getMobileStatus(status: await Permission.camera.request());
      }
    }
  }

  Future<AppPermissionStatus> _getMobileStatus({
    required PermissionStatus status,
  }) async {
    final result = _getStatus(status: status);

    if (result == AppPermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }

    return _getStatus(status: await Permission.location.request());
  }

  AppPermissionStatus _getStatus({
    required PermissionStatus status,
  }) {
    return switch (status) {
      PermissionStatus.granted => AppPermissionStatus.granted,
      PermissionStatus.denied => AppPermissionStatus.denied,
      PermissionStatus.permanentlyDenied =>
        AppPermissionStatus.permanentlyDenied,
      _ => AppPermissionStatus.denied,
    };
  }
}
