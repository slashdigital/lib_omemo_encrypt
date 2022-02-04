abstract class WhisperKey {
  WhisperKeyType get keyType;
  Type get type;

  const WhisperKey();
}

enum WhisperKeyType {
  unspecified,
  identityKey,
  identityKeyPair,
  pendingPreKey,
  preKeyPair,
  signedPreKey,
}
