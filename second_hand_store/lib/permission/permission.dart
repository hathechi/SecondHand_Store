import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermission() async {
  PermissionStatus status = await Permission.photos.status;
  if (status.isDenied || status.isPermanentlyDenied) {
    // Quyền truy cập bị từ chối hoặc bị từ chối vĩnh viễn, yêu cầu lại quyền
    PermissionStatus newStatus = await Permission.photos.request();
    if (newStatus.isGranted) {
      // Quyền truy cập được cấp,
      return true;
    }
  } else if (status.isGranted) {
    // Quyền truy cập đã được cấp, thực hiện lấy hình ảnh
    return true;
  }
  return false;
}
