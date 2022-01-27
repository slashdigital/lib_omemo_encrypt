import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';

const maximumRetainedReceivedChainKeys = 20;

class SessionState {
  final int sessionVersion = 3;
  final dynamic remoteIdentityKey = null;
  final dynamic localIdentityKey = null;
  final dynamic pendingPreKey = null;
  final String localRegistrationId = '';
  final dynamic theirBaseKey = null;
  // Ratchet parameters
  final dynamic rootKey = null;
  final dynamic sendingChain = null;
  final dynamic senderRatchetKeyPair = null;
  final List<dynamic> receivingChains =
      []; // Keep a small list of chain keys to allow for out of order message delivery.
  final int previousCounter = 0;

  findReceivingChain(dynamic theirEpheremeralPublicKey) {
    // for (var i = 0; i < this.receivingChains.length; i++) {
    //       var receivingChain = this.receivingChains[i];
    //       if (ArrayBufferUtils.areEqual(receivingChain.theirEphemeralKey, theirEphemeralPublicKey)) {
    //           return receivingChain.chain;
    //       }
    //   }
    //   return null;
  }

  addReceivingChain(dynamic theirEphemeralPublicKey, dynamic chain) {
    // this.receivingChains.push({
    //         theirEphemeralKey: theirEphemeralPublicKey,
    //         chain: chain
    //     });
    //     // We don't keep an infinite number of chain keys, as this would compromise forward secrecy.
    //     if (this.receivingChains.length > ProtocolConstants.maximumRetainedReceivedChainKeys) {
    //         this.receivingChains.shift();
    //     }
  }
}
