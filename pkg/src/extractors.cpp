#include "rprotobuf.h"
#include "fieldtypes.h"
#include "Rcppsupport.h"

namespace rprotobuf{
	
/**
 * extract a field from a message
 *
 * @param pointer external pointer to a message
 * @param name name of the field
 *
 * @return the field called "name" of the message if the 
 *         message has the field, otherwise an error is generated
 */
SEXP getMessageField( SEXP pointer, SEXP name ){
	
#ifdef RPB_DEBUG
Rprintf( "<getMessageField>\n" ) ;

PRINT_DEBUG_INFO( "pointer", pointer ) ;
PRINT_DEBUG_INFO( "name", name ) ;
#endif

	/* grab the Message pointer */
	Rcpp::XPtr<GPB::Message> message(pointer) ;

	/* the message descriptor */
	const GPB::Descriptor* desc = message->GetDescriptor() ;
	
	GPB::FieldDescriptor* field_desc = static_cast<GPB::FieldDescriptor*>(0);
	
	switch( TYPEOF( name) ){
	case STRSXP:
		{
			/* what we are looking for */
			const char * what = CHAR( STRING_ELT(name, 0 ) ) ;
			
			/* the field descriptor */
			field_desc = (GPB::FieldDescriptor*)desc->FindFieldByName( what ) ;
			
			break ;
		}
	case REALSXP:
		{
			
			/* the field descriptor */
			field_desc = (GPB::FieldDescriptor*)desc->FindFieldByNumber( static_cast<int>( REAL(name)[0] ) ) ;
			
			break ;
		}
	case INTSXP: 
		{
			/* the field descriptor */
			field_desc = (GPB::FieldDescriptor*)desc->FindFieldByNumber( INTEGER(name)[0] ) ;
			
			break ;
		}
	}
	
	if( !field_desc ){
		throwException( "could not get FieldDescriptor for field", "NoSuchFieldException" ) ;
	}
	
#ifdef RPB_DEBUG
Rprintf( "</getMessageField>\n" ) ;
#endif

	return( extractFieldAsSEXP(message, desc, field_desc) ) ;
	
}

SEXP extractFieldAsSEXP( const Rcpp::XPtr<GPB::Message>& message, const GPB::Descriptor* desc, const GPB::FieldDescriptor*  fieldDesc ){

    const Reflection * ref = message->GetReflection() ;
       
    if( fieldDesc->is_repeated() ){
    	
    	switch( GPB::FieldDescriptor::TypeToCppType(fieldDesc->type()) ){

#undef HANDLE_REPEATED_FIELD
#define HANDLE_REPEATED_FIELD(TYPE,DATATYPE) \
	case TYPE : \
		return Rcpp::wrap( RepeatedFieldImporter<DATATYPE>(ref, *message, fieldDesc) ) ; \

		HANDLE_REPEATED_FIELD(CPPTYPE_INT32, GPB::int32) ;
    		HANDLE_REPEATED_FIELD(CPPTYPE_INT64, GPB::int64) ;
    		HANDLE_REPEATED_FIELD(CPPTYPE_UINT32 , GPB::uint32) ;
    		HANDLE_REPEATED_FIELD(CPPTYPE_UINT64 , GPB::uint64) ;
    		HANDLE_REPEATED_FIELD(CPPTYPE_DOUBLE, double) ;
    		HANDLE_REPEATED_FIELD(CPPTYPE_FLOAT, float) ;
    		HANDLE_REPEATED_FIELD(CPPTYPE_BOOL, bool) ;
    		HANDLE_REPEATED_FIELD(CPPTYPE_ENUM, enum_field ) ;
    		HANDLE_REPEATED_FIELD(CPPTYPE_STRING, std::string ) ;
    		HANDLE_REPEATED_FIELD(CPPTYPE_MESSAGE, message_field ) ;
#undef HANDLE_REPEATED_FIELD

    	}
    	
    } else {
    	
    	switch( GPB::FieldDescriptor::TypeToCppType(fieldDesc->type()) ){

#undef HANDLE_SINGLE_FIELD
#define HANDLE_SINGLE_FIELD(CPPTYPE,SUFFIX) 					\
		case CPPTYPE: 									\
			return Rcpp::wrap( ref->Get##SUFFIX(*message, fieldDesc ) ) ;

		HANDLE_SINGLE_FIELD( CPPTYPE_INT32,  Int32 ); 
		HANDLE_SINGLE_FIELD( CPPTYPE_INT64,  Int64 );
		HANDLE_SINGLE_FIELD( CPPTYPE_UINT32, UInt32 ); 
		HANDLE_SINGLE_FIELD( CPPTYPE_UINT64, UInt64 );
		HANDLE_SINGLE_FIELD( CPPTYPE_DOUBLE, Double );
		HANDLE_SINGLE_FIELD( CPPTYPE_FLOAT, Float );
		HANDLE_SINGLE_FIELD( CPPTYPE_BOOL, Bool );
		HANDLE_SINGLE_FIELD( CPPTYPE_STRING, String );
#undef HANDLE_SINGLE_FIELD

		case CPPTYPE_ENUM : 
    			return Rcpp::wrap( ref->GetEnum( *message, fieldDesc )->number() ) ;
    		
    		case CPPTYPE_MESSAGE:
    			return S4_Message_( CLONE( &ref->GetMessage( *message, fieldDesc ) ) ) ;
    			break ;
    	}
    }
    return R_NilValue ; /* -Wall */
}

} // namespace rprotobuf

