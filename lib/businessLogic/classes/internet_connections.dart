import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../ui/screens/no_internet_screen.dart';

class ConnectionStatusListener {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final _singleton = ConnectionStatusListener._internal();

  ConnectionStatusListener._internal();

  bool hasShownNoInternet = false;

  //connectivity_plus
  final Connectivity _connectivity = Connectivity();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusListener getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = StreamController.broadcast();

  Stream get connectionChange => connectionChangeController.stream;

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }

  //Hook into connectivity_plus's Stream to listen for changes
  //And check the connection status out of the gate
  Future<void> initialize() async {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    await checkConnection();
  }

  //A clean up method to close our StreamController
  //Because this is meant to exist through the entire application life cycle this isn't really an issue
  void dispose() {
    connectionChangeController.close();
  }
}

bool updateConnectivity(bool hasConnection,
    ConnectionStatusListener connectionStatus, BuildContext context) {
  if (!hasConnection) {
    return connectionStatus.hasShownNoInternet = true;
  } else {
    if (connectionStatus.hasShownNoInternet) {
      return connectionStatus.hasShownNoInternet = false;
    }
    return true;
  }
}

void initNoInternetListener(BuildContext context) async {
  var connectionStatus = ConnectionStatusListener.getInstance();
  await connectionStatus.initialize();
  if (!connectionStatus.hasConnection) {
    updateConnectivity(false, connectionStatus, context);
  }
  connectionStatus.connectionChange.listen((event) {
    if (!updateConnectivity(event, connectionStatus, context)) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const NoInternetScreen()));
    } else {
      Navigator.pop(context);
    }
  });
}
