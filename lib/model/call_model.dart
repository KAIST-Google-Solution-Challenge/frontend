class CallModel {
  final DateTime datetime; // datetime of the call
  final int length; // length of call
  final String name; // 'Mother' if contact exists, else empty string
  final String number; // '010-2236-5450'
  final String path; // path of audio data of the call

  CallModel({
    required this.datetime,
    required this.length,
    required this.name,
    required this.number,
    required this.path,
  });

  // File getFile() async {
  //   // get audio data of the call from this.path
  // }
}
