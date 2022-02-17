class OldMessageCounterException implements Exception {
  OldMessageCounterException(this.detailMessage);
  final String detailMessage;

  @override
  String toString() => 'OldMessageCounterException - $detailMessage';
}
