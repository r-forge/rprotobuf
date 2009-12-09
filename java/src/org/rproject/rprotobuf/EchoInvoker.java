package org.rproject.rprotobuf ;

import com.example.tutorial.AddressBookProtos.Person ;
import com.google.protobuf.Descriptors.MethodDescriptor ;
import com.google.protobuf.Message ;
import java.io.IOException ;

public class EchoInvoker extends ProtobufMethodInvoker{
	
	public Message invoke(Message person){
		return person ;
	}
	
	public Message.Builder getInputMessageBuilder() {
		return com.example.tutorial.AddressBookProtos.Person.newBuilder() ;
	}
	
}

