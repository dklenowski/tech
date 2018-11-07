# Dart Shortcuts

## Print String

	String toString() => "Status: $status, localVideoFile: $localVideoFile";

## Shortcuts / null operators

	// assign y to x, unless y is null, otherwise assign z
	String x = y ?? z;

	// assign y to x if x is null
	String x ??= y;

	// call x.foo() if x is not null
	x?.foo();

## Shortcuts / ternary operator

	return (uid != null) ? uid : UserUtils.createEmptyUser(toEmail);


## Constructor Init

	class User implements Model {
	  final int id;
	  final String email;
	  final String token;
	  final String errorMsg;
	
	  User(Map<String, dynamic> json) :
	    id = json.containsKey('user') ? json['user']['pk'] : null,
	    email = json.containsKey('user') ? json['user']['email'] : null,
	    token = json.containsKey('token') ? json['token'] : null,
	    errorMsg = json.containsKey('non_field_errors') ? json['non_field_errors'][0] : null;

## Time

    DateTime now = DateTime.now();
    Duration diff = now.difference(_tokenUpdateTime);
    if (diff.inHours >= tokenRefreshInterval) {
      logger.info("refreshing token: lastTokenUpdateTime=$_tokenUpdateTime diff=${diff.inHours}");
      return _getToken();
    }


## Catching Specific Exceptions

    try {
      return _values.firstWhere((e) => e.toString().endsWith(val));
    } on IterableElementError catch (error) {
      return _values[_defaultIndex];
    }

    