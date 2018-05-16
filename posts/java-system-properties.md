Categories: java
Tags: system properties


        public class Demo {
          public static void main(String[] args) {
            String pDebug = System.getProperty("DEBUG");
        
            if ( pDebug ) {
              System.out.println("In debug mode");
            }
          }
        }

- To Run:

        # java -DDEBUG=1 Demo