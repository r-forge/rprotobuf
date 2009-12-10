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

import com.google.protobuf.Message ;

/**
 * handles a protobuf rpc over http request
 */
public class ProtobufHandler implements HttpHandler {
  
	/**
	 * prints debugging output on System.out
	 */ 
	public static boolean verbose = true ;
	
	/**
	 * handles the request
	 */
	public void handle(HttpExchange xchg) throws IOException {
    if( verbose) System.out.println( "ProtobufHandler >> handle" ) ;
		
    String http_method = xchg.getRequestMethod() ;
		/* TODO: check it is POST and send unimplemented otherwise */
		
		if( verbose ) System.out.println( "http method : " + http_method ) ;
		
		Headers headers = xchg.getRequestHeaders();
		
		/* print the headers */
		if( verbose ){
		  Set<Map.Entry<String, List<String>>> entries = headers.entrySet();
		  for (Map.Entry<String, List<String>> entry : entries)
    		System.out.println(entry.toString());
    }
		
    int contentLength = Integer.parseInt( headers.getFirst("Content-Length").replace( " " ,"") ) ;
    
    String uri = xchg.getRequestURI().toString() ;
    StringTokenizer tok = new StringTokenizer( uri, "/" ) ;
    String service = tok.nextToken() ;
    String method = tok.nextToken() ;
    if( verbose ){
    	System.out.println( "rpc method : {" + service + "." + method +"}" ) ;
    }
    
    ProtobufMethodInvoker invoker = ProtobufMethodPool.get( service + "." + method );
    if( invoker == null ){
    	/* we don't even bother reading the body since we don't know what to do with it */
    	xchg.sendResponseHeaders( 501, 0 ) ;
    	xchg.close() ;
    	return ;
    }
    InputStream input = xchg.getRequestBody() ;
    Message result  = null ;
    try{
    	result = invoker.invoke( input ) ;
    } catch( IOException e){
    	xchg.sendResponseHeaders( 500, 0 ) ;
    	xchg.close() ;
    	return ;
    }
    xchg.sendResponseHeaders(200, result.getSerializedSize() );
    OutputStream os = xchg.getResponseBody();
    if( verbose ){
    	System.out.println( "output message : \n==================\n" + result  + "\n========================\n") ;
    }
    result.writeTo( os ) ;
    input.close() ;
    os.close() ;
    xchg.close() ;
  }
}

