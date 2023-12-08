import 'package:firebase_database/firebase_database.dart';

class RealtimeCURD {
  static void increaseValueByOne(String child) {
    var ref = FirebaseDatabase.instance.ref();
    ref.child(child).once().then((response) {
      ref.update({
        child: (response.snapshot.value as int) + 1,
      });
    });
  }
}
