package org.rproject.rprotobuf ;

import org.rproject.rprotobuf.HelloWorld.HelloWorldRequest ;
import org.rproject.rprotobuf.HelloWorld.HelloWorldResponse ;
import com.google.protobuf.Message ;

@MethodImplementation("rprotobuf.HelloWorldService.HelloWorld")
public class HelloWorldInvoker extends ProtobufMethodInvoker<HelloWorldRequest,HelloWorldResponse>{
	
	public HelloWorldResponse invoke(HelloWorldRequest request){
		return HelloWorldResponse.newBuilder().setMessage( "hello world").build() ;
	}
	
	public HelloWorldRequest getInputDefaultInstance(){
		return org.rproject.rprotobuf.HelloWorld.HelloWorldRequest.getDefaultInstance() ;
	}
	
}

