package org.rproject.rprotobuf ;

/**
 * invokes a protobuf rpc method
 */
public interface ProtobufMethodInvoker {
	
	/**
	 * invokes a protobuf rpc method and returns the result payload
	 * 
	 * @param input the input message payload
	 *
	 * @return the result message payload
	 */
	public byte[] invoke( byte[] input ) ;

}

