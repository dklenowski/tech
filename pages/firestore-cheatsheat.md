## Future

### single call with exception

  Future<FlipdareUserInfo> _load(FlipdareUserType type, String uid) {
    String userType = flipdareUserTypeToString(type);
    _logger.info("loading user data for $uid who is a $userType");

    return _store
        .collection(userCollection)
        .document(uid)
        .get()
        .then((snapshot) => snapshot == null
            ? FlipdareUserInfo._(uid, <String, dynamic>{})
            : FlipdareUserInfo._(uid, snapshot.data))
        .catchError((error) {
      _logger.severe("Error retreiving user info : $error");
      throw DatabaseException(
          type: DatabaseExceptionType.Connection,
          recoverable: true,
          message: "Unable to load your profile data, please try again soon",
          cause: error);
    });

    
## Retreive List

    _store
        .collection(userCollection)
        .where('uid', isEqualTo: uid)
        .getDocuments()
        .then((result) {
      List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        _logger.info("no user data for new user $uid (type=$type)");
        _userInfo = FlipdareUserInfo._({type: type, uid: uid});
      } else {
        _userInfo = FlipdareUserInfo._(documents[0].data);
        _logger.info("found user $_userInfo");
      }
      return _userInfo;
    }).catchError((error) {
      _logger.severe("Error retreiving user info : $error");
      throw DatabaseException(type: DatabaseExceptionType.Connection,
          recoverable: true,
          message: "Unable to load your profile data, please try again soon",
          cause: error);
    });