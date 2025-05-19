import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class PermissionRequests extends StatefulWidget {
  const PermissionRequests({required this.audioRoomCall, super.key});
  final Call audioRoomCall;

  @override
  State<PermissionRequests> createState() => _PermissionRequestsState();
}

class _PermissionRequestsState extends State<PermissionRequests> {
  final List<StreamCallPermissionRequestEvent> _permissionRequests = [];

  @override
  void initState() {
    super.initState();

    widget.audioRoomCall.onPermissionRequest = (permissionRequest) {
      setState(() {
        _permissionRequests.add(permissionRequest);
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._permissionRequests.map(
          (request) {
            return Container(
              padding: const EdgeInsets.all(8),
              color: Colors.white,
              child: Row(
                children: [
                  Text(
                      '${request.user.name} requests to ${request.permissions}'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: () async {
                      await widget.audioRoomCall.grantPermissions(
                        userId: request.user.id,
                        permissions: request.permissions.toList(),
                      );

                      setState(() {
                        _permissionRequests.remove(request);
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      setState(() {
                        _permissionRequests.remove(request);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
