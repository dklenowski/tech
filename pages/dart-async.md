# Dart Async scenarios

# Async Basics

	import 'dart:async';
	
	class AClass {
	  Future<String> doASomething() async =>
	      Future.delayed(Duration(seconds: 1), () => "news");
	
	}
	
	class BClass {
	  
	  Future<String> doBSomething() async {
	    AClass a = AClass();
	    return a.doASomething();
	  }
	  
	}
	
	void main() {
	  BClass b = BClass();
	  b.doBSomething().then((msg) {
	    print("Received message $msg");
	  });
	}

## Output

	Received message news


# Storing Local Variables before return from an async


	import 'dart:async';
		
	class AClass {
		
	  Future<String> doASomething() async =>
	      Future.delayed(Duration(seconds: 1), () => "news");
		
	}
		
	class BClass {
	  String lastMessage;
		
	  Future<String> doBSomething() async {
	    AClass a = AClass();
	    return a.doASomething().then((msg) {
	      lastMessage = msg;
	    }).then((_) {
	      return lastMessage;
	    });
	  }
	  
	}
		
	void main() {
	  BClass b = BClass();
	  b.doBSomething().then((msg) {
	    print("Received message=$msg");
	    print("Last message=${b.lastMessage}");
	  });
	}

## Output

	Received message=news
	Last message=news


# Catching Specific Exceptions

	import 'dart:async';
	
	class FirstException implements Exception {
	  final String message;
	  final code;
	
	  FirstException(this.code, this.message);
	
	  @override
	  String toString() {
	    return "FirstException ($code): $message";
	  }
	}
	
	class SecondException implements Exception {
	  final String message;
	
	  SecondException(this.message);
	
	  @override
	  String toString() {
	    return "SecondException: $message";
	  }
	}
	
	class AClass {
	  Future<String> doASomething() async =>
	      Future.delayed(Duration(seconds: 1), () => "news");
	}
	
	class BClass {
	  String lastMessage;
	
	  Future<String> doFirstThrow() async {
	    AClass a = AClass();
	    return a.doASomething().then((msg) {
	      if (msg != null) {
	        throw FirstException(1, "First Exception thrown.");
	      }
	    }).then((_) {
	      return lastMessage;
	    });
	  }
	  
	    Future<String> doSecondThrow() async {
	    AClass a = AClass();
	    return a.doASomething().then((msg) {
	      if (msg != null) {
	        throw SecondException("Second Exception thrown.");
	      }
	    }).then((_) {
	      return lastMessage;
	    });
	  }
	}
	
	void main() {
	  BClass b = BClass();
	  b.doFirstThrow().then((msg) {
	    print("Received message $msg");
	  }).catchError((error) {
	    print("Code=${(error as FirstException).code}");
	    FirstException first = error as FirstException;
	    print("First Error thrown ${first.code}: ${first.message}");
	  }, test: (e) => e is FirstException).catchError((error) {
	    print("Unknown error thrown $error");
	  });
	  
	  b.doSecondThrow().then((msg) {
	    print("Received message $msg");
	  }).catchError((error) {
	    print("First Error thrown $error");
	  }, test: (e) => e is FirstException).catchError((error) {
	    print("Unknown error thrown $error");
	  });
	}
