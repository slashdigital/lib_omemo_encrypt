// import 'dart:typed_data';

// import 'package:pointycastle/paddings/pkcs7.dart';

// // TODO: refactor

// Uint8List pad(Uint8List bytes, int blockSize) {
//   final padLength = blockSize - (bytes.length % blockSize);
//   final padded = Uint8List(bytes.length + padLength)..setAll(0, bytes);
//   PKCS7Padding().addPadding(padded, bytes.length);
//   return padded;
// }

// Uint8List unpad(Uint8List padded) =>
//     padded.sublist(0, padded.length - PKCS7Padding().padCount(padded));
