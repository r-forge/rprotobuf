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
public abstract class ProtobufMethodInvoker<INPUT_TYPE extends Message,OUTPUT_TYPE extends Message> {
	
	/**
	 * invokes the method
	 *
	 * @param input input message
	 * @return the result of the rpc method
	 */
	public abstract OUTPUT_TYPE invoke( INPUT_TYPE input ) ;
	
	/**
	 * returns a prototype of the input type
	 */
	public abstract INPUT_TYPE getInputDefaultInstance() ;
	
	/**
	 * Reads the input message from the input stream and 
	 * write the output message to the output stream
	 */
	@SuppressWarnings("unchecked")
	public OUTPUT_TYPE invoke( InputStream input ) throws IOException {
		INPUT_TYPE input_default_instance = getInputDefaultInstance() ;
		Builder input_builder = input_default_instance.newBuilderForType() ;
		input_builder.mergeFrom( input ) ;
		OUTPUT_TYPE output_message = invoke( (INPUT_TYPE)input_builder.buildPartial() ) ;
		return output_message ;
	}
	
	
}

