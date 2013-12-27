#include "rprotobuf.h"
#include "RWarningErrorCollector.h"

namespace rprotobuf {

void RWarningErrorCollector::AddError(const std::string& filename, int line,
                                      int column, const std::string& message) {

    Rprintf("%s:%d:%d:%s\n", filename.c_str(), line + 1, column + 1,
            message.c_str());
}

}  // namespace rprotobuf
