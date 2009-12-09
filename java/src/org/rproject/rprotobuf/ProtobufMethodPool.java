package org.rproject.rprotobuf ;

import java.util.HashMap ;

/**
 * simple storage of ProtobufMethodInvoker
 */
public class ProtobufMethodPool {

	private static HashMap<String,ProtobufMethodInvoker> map = init() ;
	
	private static HashMap<String,ProtobufMethodInvoker> init(){
		HashMap<String,ProtobufMethodInvoker> m = new HashMap<String,ProtobufMethodInvoker>() ;
		m.put( "tutorial.EchoService.Echo", new EchoInvoker() ) ;
		return m ;
	}
	
	/**
	 * is the method implemented
	 *
	 * @param method full name (including scope) of the rpc method
	 * @return true if the method is implemented
	 */
	public static boolean has( String method ){
		return map.containsKey( method ) ;
	}
	
	/**
	 * gets the method invoker
	 *
	 * @param method full name (including scope) of the rpc method
	 * @return the method invoker, or null
	 */
	public static ProtobufMethodInvoker get(String method){
		return map.get( method ) ;
	}
	
}
