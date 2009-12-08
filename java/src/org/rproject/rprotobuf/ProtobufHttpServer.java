package org.rproject.rprotobuf ;

import java.io.IOException;
import java.io.OutputStream;
import java.io.InputStream;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;
import java.net.InetSocketAddress;

import java.util.StringTokenizer ;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * protobuf rpc over http
 */
public class ProtobufHttpServer {
  
	public static void main(String[] args) throws IOException {
    HttpServer server = HttpServer.create(new InetSocketAddress(4444), 0);
    server.createContext("/", new ProtobufHandler());
    server.start();
  }
}

class ProtobufHandler implements HttpHandler {
	  
  	public void handle(HttpExchange xchg) throws IOException {
	    System.out.println( "ProtobufHandler >> handle" ) ;
  		String http_method = xchg.getRequestMethod() ;
  		/* TODO: check it is POST and send unimplemented otherwise */
  		
  		System.out.println( "http method : " + http_method ) ;
  		
  		Headers headers = xchg.getRequestHeaders();
  		
  		  Set<Map.Entry<String, List<String>>> entries = headers.entrySet();
  		  for (Map.Entry<String, List<String>> entry : entries)
      		System.out.println(entry.toString());

  		
	    int contentLength = Integer.parseInt( headers.getFirst("Content-Length").replace( " " ,"") ) ;
	    
	    String uri = xchg.getRequestURI().toString() ;
	    StringTokenizer tok = new StringTokenizer( uri, "/" ) ;
	    String service = tok.nextToken() ;
	    String method = tok.nextToken() ;
	    
	    byte[] body = new byte[contentLength] ;
	    InputStream input = xchg.getRequestBody() ;
	    
	    int n = 0 ;
	    int r ;
	    while( n<contentLength ){
	    	r = input.read( body, n, (contentLength-n) ) ;
	    	if( r <= 0 ) break ;
	    	System.out.println( " read " + r + " bytes" ) ;
	    	n += r ;
	    }
	    System.out.println( "finished reading body" ) ; 
	    
	  	xchg.sendResponseHeaders(200, body.length );
	  	OutputStream os = xchg.getResponseBody();
	  	os.write( body );
	  	input.close() ;
	    os.close();
	  }
	}
  
