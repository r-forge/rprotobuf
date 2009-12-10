package org.rproject.rprotobuf ;

import java.util.HashMap ;

/**
 * simple storage of ProtobufMethodInvoker
 */
public class ProtobufMethodPool {

	private static HashMap<String,ProtobufMethodInvoker> map = 
		new HashMap<String,ProtobufMethodInvoker>() ;
	static{
		register("tutorial.EchoService.Echo", new EchoInvoker() ) ;
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
	
	public static void register( String method, ProtobufMethodInvoker invoker ){
		map.put( method, invoker ) ;
	}
	
	
}
