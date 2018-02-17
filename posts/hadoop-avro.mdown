Categories: java
Tags: java
      hadoop
      hive

## Create avro format file

e.g for tomcataccess

    {"namespace": "com.tomcat.avro",
     "type": "record",
     "name": "TomcatEntry",
     "fields": [
         {"name": "internalHost", "type": "string"},
         {"name": "datet", "type": "string"},
         {"name": "xForwardedFor", "type": "string"},
         {"name": "remoteUser", "type": "string"},
         {"name": "remoteMethod", "type": "string"},
         {"name": "requestPath", "type": "string"},
         {"name": "status", "type": "int"},
         {"name": "bytesSent", "type": "string"},
         {"name": "referer", "type": "string"},
         {"name": "userAgent", "type": "string"},
         {"name": "hostname", "type": "string"},
         {"name": "requestDurationMs", "type": "int"},
         {"name": "requestDurationS", "type": "float"},
         {"name": "requestProtocol", "type": "string"},
         {"name": "requestThread", "type": "string"},
         {"name": "sessionId", "type": "string"},
         {"name": "ifNoneMatch", "type": "string"},
         {"name": "eTag", "type": "string"},
         {"name": "queryParams", "type": "string"}
     ]
    }


## Compile avro schema files

- The jar can be found in the avro-libs cloudera package.

        java -jar /usr/lib/avro/avro-tools-1.7.6-cdh5.3.1.jar compile schema <file.avro> <output-dir>


# Adding to flume

## For the Interceptor

### Flume configuration

    tomcataccess.sources.netcat-tomcataccess.type = netcat
    ....
    tomcataccess.sources.netcat-tomcataccess.interceptors = timestamp security
    tomcataccess.sources.netcat-tomcataccess.interceptors.security.type = com.ebay.ecg.so.TomcatInterceptor$Builder

### Code Example


    package com.cloud;
    
    import org.apache.flume.Context;
    import org.apache.flume.Event;
    import org.apache.flume.interceptor.Interceptor;
    
    public class TomcatInterceptor implements Interceptor {
    
        public void initialize() { }
    
        public Event intercept(Event event) {
            // do something interesting
            return event;
        }
    
        public List<Event> intercept(List<Event> list) {
            List<Event> enriched = new ArrayList<>(list.size());
            for (Event event:list) {
                Event e = intercept(event);
                enriched.add(e);
            }
    
            return enriched;
        }
    
        public void close() { }
    
    
        public static class Builder implements Interceptor.Builder {
        
            public Interceptor build() {
                return new TomcatInterceptor();
            }
        
            public void configure(Context context) { }
        }
    }




## For the serializer

### Flume configuration

    tomcataccess.sinks.hdfs-tomcataccess-1.type = hdfs
    tomcataccess.sinks.hdfs-tomcataccess-1.serializer = com.ebay.ecg.so.TomcatSerializer$Builder

### Code Example

    package com.cloud
    
    import org.apache.avro.Schema;
    import org.apache.avro.file.DataFileWriter;
    import org.apache.avro.generic.GenericDatumWriter;
    import org.apache.avro.io.DatumWriter;
    import org.apache.flume.Event;
    import org.apache.flume.serialization.EventSerializer;
    import org.apache.avro.file.CodecFactory;
    import org.apache.avro.AvroRuntimeException;
    import java.io.IOException;
    import java.io.OutputStream;
    import org.apache.flume.conf.Configurable;
    import org.apache.flume.Context;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;
    import static org.apache.flume.serialization.AvroEventSerializerConfigurationConstants.*;
    
    public class TomcatSerializer implements EventSerializer, Configurable {
    
        private TomcatSerializer(OutputStream out) {
            this.out = out;
        }
    
        @Override
        public void configure(Context context) {
            syncIntervalBytes =
                    context.getInteger(SYNC_INTERVAL_BYTES, DEFAULT_SYNC_INTERVAL_BYTES);
            compressionCodec =
                    context.getString(COMPRESSION_CODEC, DEFAULT_COMPRESSION_CODEC);
        }
    
        @Override
        public void afterCreate() throws IOException { }
    
        @Override
        public void afterReopen() throws IOException {
            // impossible to initialize DataFileWriter without writing the schema?
            throw new UnsupportedOperationException("Avro API doesn't support append");
        }
    
        @Override
        public void write(Event event) throws IOException {
            String body = new String(event.getBody());
            String fields[] = body.split("\\|");
            if (fields.length != 19) {
                logger.warn("found an invalid tomcat access line (" + body + ")");
                return;
            }
    
            TomcatEntry entry;
            try {
                entry = new TomcatEntry().newBuilder()
                        .setInternalHost(fields[0])
                        .setDatet(fields[1])
                        .setXForwardedFor(fields[4])
                        .setRemoteUser(fields[5])
                        .setRemoteMethod(fields[6])
                        .setRequestPath(fields[7])
                        .setStatus(Integer.valueOf(fields[8]))
                        .setBytesSent(fields[9])
                        .setReferer(fields[10])
                        .setUserAgent(fields[11])
                        .setHostname(fields[12])
                        .setRequestDurationMs(Integer.valueOf(fields[13]))
                        .setRequestDurationS(Float.valueOf(fields[14]))
                        .setRequestProtocol(fields[15])
                        .setRequestThread(fields[16])
                        .setSessionId(fields[17])
                        .setIfNoneMatch(fields[18])
                        .setETag(fields[19])
                        .setQueryParams(fields[20]).build();
            } catch (NumberFormatException nfe) {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < fields.length; i++ ) {
                    sb.append("\t" + i + "=" + fields[i] + "\n");
                }
                logger.warn("really unable to process line " + body + "\n" + sb.toString(), nfe);
                return;
            }
    
            if (dataFileWriter == null) {
                initialize();
            }
    
            dataFileWriter.append(entry);
        }
    
        @Override
        public void flush() throws IOException {
            if (dataFileWriter != null) {
                dataFileWriter.flush();
            }
        }
    
        @Override
        public void beforeClose() throws IOException { }
    
        @Override
        public boolean supportsReopen() {
            return false;
        }
    
        private void initialize() throws IOException {
            Schema schema = TomcatEntry.getClassSchema();
            writer = new GenericDatumWriter<>(schema);
            dataFileWriter = new DataFileWriter<>(writer);
            dataFileWriter.setSyncInterval(syncIntervalBytes);
    
            try {
                CodecFactory codecFactory = CodecFactory.fromString(compressionCodec);
                dataFileWriter.setCodec(codecFactory);
            } catch (AvroRuntimeException e) {
                logger.warn("Unable to instantiate avro codec with name (" +
                        compressionCodec + "). Compression disabled. Exception follows.", e);
            }
    
            dataFileWriter.create(schema, out);
        }
    
        public static class Builder implements EventSerializer.Builder {
    
            @Override
            public EventSerializer build(Context context, OutputStream out) {
                TomcatSerializer writer = new TomcatSerializer(out);
                writer.configure(context);
                return writer;
            }
    
        }
    }


