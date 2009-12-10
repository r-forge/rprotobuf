package org.rproject.rprotobuf ;

import com.example.tutorial.AddressBookProtos.Person ;
import com.google.protobuf.Message ;

@MethodImplementation("tutorial.EchoService.Echo")
public class EchoInvoker extends ProtobufMethodInvoker<Person,Person>{
	
	public Person invoke(Person person){
		return person ;
	}
	
	public Person getInputDefaultInstance(){
		return com.example.tutorial.AddressBookProtos.Person.getDefaultInstance() ;
	}
	
}

