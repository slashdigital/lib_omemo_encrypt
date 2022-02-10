class InvalidSignatureException implements Exception {
  InvalidSignatureException(this.detailMessage);
  final String detailMessage;

  @override
  String toString() => 'InvalidSignatureException - $detailMessage';
}
