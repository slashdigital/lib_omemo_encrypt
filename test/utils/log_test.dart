import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
import 'package:lib_omemo_encrypt/utils/log.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'log_test.mocks.dart';

// class MockLog extends Mock implements Log {}

@GenerateMocks([Log])
void main() {
  final log = MockLog();
  const tag = 'log_test';
  const message = 'print debug';
  setUpAll(() async {});
  setUp(() {});
  group('Log', () {
    test('Should call function log', () async {
      log.d(tag, message);
      logInvocations([log]);
      verify(log.d(tag, message));
    });
  });
}
