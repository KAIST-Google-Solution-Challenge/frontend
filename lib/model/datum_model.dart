enum Sender {
  user, // me
  opponent, // you
}

class Datum {
  final String text;
  final Sender sender;

  Datum({required this.text, required this.sender});
}
