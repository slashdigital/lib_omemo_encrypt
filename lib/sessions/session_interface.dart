const maximumSessionStatesPerIdentity = 20;

abstract class SessionInterface {
  mostRecentState();
  addState();
  removeState();
}
