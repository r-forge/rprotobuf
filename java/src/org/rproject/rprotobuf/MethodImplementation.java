package org.rproject.rprotobuf ;

import java.lang.annotation.ElementType;
import java.lang.annotation.Target;

@Target(ElementType.TYPE)
public @interface MethodImplementation {
        String value() ;
}
