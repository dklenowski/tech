Categories: c++
Tags: log4cxx

## Log4Cxx Examples

- Using `basicconfigurator`

        // includes
        #include <log4cxx/logger.h>
        #include <log4cxx/basicconfigurator.h>
        #include <log4cxx/helpers/exception.h>
        #include <string>
        
        using namespace log4cxx;
        using namespace log4cxx::helpers;
        using std::string;
        
        // in main
        LoggerPtr logger(Logger::getLogger("MyApp"));
        
        try {
          BasicConfigurator::configure();
        } catch ( Exception& ) {
          // do something
        }
        
        LOG4CXX_INFO(logger, "Entering application");
        [/sourcecode]
        Using domconfigurator
        
        [sourcecode language="cpp"]
        // includes
        #include <log4cxx/logger.h>
        #include <log4cxx/xml/domconfigurator.h>
        #include <log4cxx/helpers/exception.h>
        # include <string>
        
        using namespace log4cxx;
        using namespace log4cxx::helpers;
        using namespace log4cxx::xml;
        using std::string;
        
        // in main
        LoggerPtr logger(Logger::getLogger("MyApp"));
        string configfile("/tmp/log4cxx.xml");
        
        try {
          DOMConfigurator::configure(configfile);
        } catch ( Exception& ) {
          // do something
        }
        
        LOG4CXX_INFO(logger, "Entering application");
