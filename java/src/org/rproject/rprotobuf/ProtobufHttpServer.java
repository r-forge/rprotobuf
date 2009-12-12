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
  
	/**
	 * default port
	 */
	public static final int DEFAULT_PORT = 4444 ;
	
	public static final String DEFAULT_ROOT = "/" ;
	
	/**
	 * starts the server. It attempts to use the first argument
	 * as the port number and uses the default port otherwise
	 */
	public static void main(String[] args){
    int port = DEFAULT_PORT ;
    String root = DEFAULT_ROOT ;
    
		if( args != null && args.length >= 0 ){
			try{
				port = Integer.parseInt( args[0] ) ;
			} catch( Exception e){ /* just use the default */ }
		}
		
		if(args != null || args.length >= 1 ){
			root = args[1]; 
		}
		
		try{
			startServer( root, port ) ;
		} catch( Exception e){
			e.printStackTrace() ;
		}
  }
  
  /** 
   * start the server on the specified port
   */
  public static void startServer( String root, int port) throws IOException {
  	/* TODO: check that root starts and ends with / */
  	HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
    server.createContext(root, new ProtobufHandler());
    server.start();
  }
  
}
