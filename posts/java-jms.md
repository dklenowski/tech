Categories: java
            jms
Tags: jms

## Java JMS

- Peer to Peer (messaging client can send messages to and receive messages from any other client).
- Each client connects to messaging agent (provides facilities for creating, receiving and reading messages).
- Sender and receiver need to know only what message format and destination to use.
- Allot “looser” than RMI (which is tightly coupled).

- Advantages
  - Loosely coupled.
  - Messages can be asynchronous.
  - Reliable.

## Architecture

- Composed of:

  - JMS Provider - Messaging system that implements the JMS interfaces.
  - JMS Clients - Produce / consume messages.
  - Messages - Objects, communicate information between clients.
  - Administered Objects - Preconfigured JMS objects created by an administrator for use of clients.
  - Native clients - Use another messaging products native client API instead of JMS.

## Administered Objects

- Consist of connection factories and destinations.
- These destinations and connection factories are bind’ed into a JNDI API namespace.

## Messaging Domains

- JMS implements either publish/subscribe or point to point (separate domain for each).

## Point to Point (PTP)

- Each message addressed to a specific queue.
- Receiving clients extract messages from the queue.
- Queues retain all messages until they are consumed or expired.
- Characteristics:
  - Each message has only 1 consumer.
  - Sender /receiver have no timing dependencies.
  - Receiver ack’s successful processing of a message.

## Publish / Subscribe

- Clients address messages to a topic.
- Publishes / Subscribes usually anonymous and may dynamically publish or subscribe to the content hierarchy.
- Topics retain messages as long as it takes to distribute them to current subscribers.
- Characteristics:
  - Each message may have multiple subscribers.
  - Has a timing dependency. i.e. client can only consume messages after it has subscribe to a topic.
  - Durable subscriptions
    - Increase flexibility in publish/subscribe.
    - Can receive messages sent while the subscribes are not active.

## Message Consumption

- Two ways:
  - Synchronously
    - Subscriber/ receiver explicitly fetches the message from the destination by calling the `receive()` method.
  - Asynchronously
    - Client can register a message listener with a consumer.
    - Similar to an event listener.
    - When a message arrives, JMS provider delivers the message by calling the listeners `onMessage()` method.

## API

                        ConnectionFactory
                              |
                              | creates
                              |
                              \/
                          Connection
                              |
                              | creates
                              |
                  creates    \/   creates
        Message <---------- Session --------------> Message
        Producer                                    Consumer
          |                                         |
          | sends to                                | receives from
          \/                                        \/
        Destination                           Destination

### ConnectionFactory

 - Object, client uses to create a connection with a provider.
- Encapsulates set of connection configuration parameters that defined by administrator.
- At beginning of JMS client, perform a JNDI lookup of `ConnectionFactory`.

        Context ctx = new InitialContext();
        QueueConnectionFactory factory = (QueueConnectionFactory)ctx.lookup("ConnectionFactory");

- Note Calling InitialContext with no parameters results in a search of the current classpath for a vendor-specific file jndi.properties.

### Process

1. Create a JNDI API `InitialContext` object if none exists.
2. Look up connection factory and queue.
3. Create a connection and a session.
4. Create a QueueSender.
5. Create a TextMessage.
6. Send 1 or more messages to the queue.
6. Send 1 or more messages to the queue.
7. Create a non text control message indication end of messages.