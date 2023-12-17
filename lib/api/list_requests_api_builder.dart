import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:etouch/api/api_response.dart';
import 'package:etouch/main.dart';
import 'package:flutter/material.dart';

class ListAPIWidgets<T extends List<APIResponse>> extends StatefulWidget {
  const ListAPIWidgets(
      {Key? key, required this.request, required this.onSuccessfulResponse})
      : super(key: key);
  final Future<T> request;
  final Widget Function(AsyncSnapshot<T>) onSuccessfulResponse;

  @override
  State<ListAPIWidgets<T>> createState() => _APIWidgetState<T>();
}

class _APIWidgetState<T extends List<APIResponse>>
    extends State<ListAPIWidgets<T>> {
  final Connectivity connectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: widget.request,
      builder: (context, AsyncSnapshot<T> snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          for (APIResponse item in snap.data ?? []) {
            if (item.statusCode == 401) {
              logoutUser(context);
              return const SizedBox.shrink();
            }
          }
          if (!snap.hasError && snap.hasData) {
            return widget.onSuccessfulResponse(snap);
          } else {
            return hasConnection();
          }
        }
      },
    );
  }

  Widget hasConnection() {
    return FutureBuilder<ConnectivityResult>(
      future: connectivity.checkConnectivity(),
      builder: (context, snap) {
        if (snap.data == ConnectivityResult.none) {
          return Center(
            child: Text(appTxt(context).checkInternetMessage),
          );
        } else {
          return Center(
            child: Text(appTxt(context).emptyDataError),
          );
        }
      },
    );
  }
}
