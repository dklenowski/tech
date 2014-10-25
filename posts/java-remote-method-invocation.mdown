Categories: java
Tags: rmi


- Used to execute code on other machines.
- Uses interfaces.

### Guidelines for remote interface

- Remote interface must be public (otherwise error).
- Note, an interface and all of its methods are automatically public.
- Remote interface must extend the interface `java.rmi.Remote`.
- Each method in the remote interface must declare `java.rmi.RemoteException` in its `throws()` clause (in addition to any application specific exceptions).
- A remote object passed as an argument or return value (either directly or embedded within a local object) must be declared as the remote interface, not the implementation class.

### Creating the Server

1. Create the server class.
  - Must extend `UnicastRemoteObject`
  - Must implement the remote interface.

2. Define the constructor for the remote object.
  - Even if only calls the base class constructor.
  - Since it must throw a RemoteException

3. Set up the registry.
  - Either at a console:

            /usr/j2se/jre/bin/rmiregistry [port]

  - Or within the class (can only use this method if your program is the only one that is going to use the registry).

            LocateRegistry.createRegistry(<port>);

4. Create and install the security manager.
  - For java use the `RMISecurityManager()`

            System.setSecurityManager(new RMISecurityManager());

5. Create 1 or more instances of the remote object.

6. Register at least one of the remote objects with the RMI remote object registry

  - Used for bootstrapping.
  - Format:

            Naming.bind("//[host]:[port]/[name]", [instance]);
            
            [host]      The IP address/DNS hostname of the server.
            [port]      The port that was registered in (3).
                        The default port is 1099 .
            [name]      The name of the service (arbitrary)
                        Usually the server class name, but must be unique in the registry
            [instance]  The instance of the server class that was defined in (5).

  - e.g.

            Naming.bind("//192.168.1.1:2005/time_rmi", tr);

7. Shut down the RMI registry entry.
  - e.g.

            Naming.unbind();

### Creating the Client

1. Create a remote interface	Must extend the interface `java.rmi.Remote`.
  - Each method in the remote interface must throw a `java.rmi.RemoteException`.

2. Create the remote object	a remote object passed as an argument or return value (either directly or embedded within a local bject) must be declared as the remote interface not the implementation class.

3. Define methods
  - Only methods in the remote interface are available to the remote client.


### Creating the Stubs

- Must create stubs and skeletons that provide network connection operations and allow remote method invocation.
- Any objects that you pass into or return from a remote object must implement `Serializable` if you want to pass remote references instead of the entire objects.
- The objects arguments can implement Remote (stubs and skeletons automatically perform serialisation and deserialization).
- To create stubs / skeletons use the `rmic` tool on your compiled code (and it automatically creates the necessary files).
- e.g. (Note `rmic` will search the `classpath`)

          rmic [class-file]

          [class-file] - The name of the class file with the ".class" omitted.
