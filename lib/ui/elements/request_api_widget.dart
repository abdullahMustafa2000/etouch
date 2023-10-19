import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:etouch/main.dart';
import 'package:flutter/material.dart';

class RequestAPIWidget<T> extends StatefulWidget {
  const RequestAPIWidget(
      {Key? key, required this.request, required this.onSuccessfulResponse})
      : super(key: key);
  final Future<T> request;
  final Widget Function(AsyncSnapshot<T>) onSuccessfulResponse;

  @override
  State<RequestAPIWidget<T>> createState() => _RequestAPIWidgetState<T>();
}

class _RequestAPIWidgetState<T> extends State<RequestAPIWidget<T>> {
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
          return Center(child: Text(appTxt(context).checkInternetMessage),);
        } else {
          return Center(child: Text(appTxt(context).emptyDataError),);
        }
      },
    );
  }
}
