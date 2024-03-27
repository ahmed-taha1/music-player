import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestSongsPermission() async {
  try {
    final bool audioGranted = await Permission.audio.isGranted;
    final bool storageGranted = await Permission.storage.isGranted;
    if (!audioGranted || !storageGranted) {
      final Map<Permission, PermissionStatus> statuses =
          await [Permission.audio, Permission.storage].request();

      if(statuses[Permission.audio]  == PermissionStatus.denied || statuses[Permission.storage] == PermissionStatus.denied){
        await openAppSettings();
      }
    }
  } catch (e) {
    debugPrint('Error requesting permission: $e');
  }
}
