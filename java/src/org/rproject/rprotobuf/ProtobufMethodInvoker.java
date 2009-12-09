package org.rproject.rprotobuf ;

import com.google.protobuf.Message ;
import com.google.protobuf.Message.Builder ;
import com.google.protobuf.DescriptorProtos.FileOptions ;
import com.google.protobuf.Descriptors.FileDescriptor ;
import com.google.protobuf.Descriptors.MethodDescriptor ;
import com.google.protobuf.Descriptors.Descriptor ;

import java.io.InputStream ;
import java.io.OutputStream ;

import java.io.IOException ;

/**
 * invokes a protobuf rpc method
 */
public abstract class ProtobufMethodInvoker {
	
	/**
	 * invokes a protobuf rpc method and returns the result payload
	 * 
	 * @param input the input message payload
	 *
	 * @return the result message payload
	 */
	public abstract Message invoke( Message input ) ;
	
	public abstract Builder getInputMessageBuilder() ;
	
	/**
	 * Reads the input message from the input stream and 
	 * write the output message to the output stream
	 */
	public Message invoke( InputStream input ) throws IOException {
		Builder input_builder = getInputMessageBuilder() ;
		input_builder.mergeFrom( input ) ;
		Message input_message = input_builder.buildPartial() ;
		Message output_message = invoke( input_message ) ;
		return output_message ;
	}
	
	
}

