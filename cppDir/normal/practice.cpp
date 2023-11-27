#include <iostream>
#include <cstdint>

int main() {
    // this is n =  2.1 billion and 1, 3n + 1
    // this is being used to test limits of cpp uint32
    uint64_t myUnsignedInt64 = 6300000004;

    std::cout << "Size of myUnsignedInt64: " << sizeof(myUnsignedInt64) << " bytes" << std::endl;
   std::cout << "Contents of myUnsignedInt64: " << myUnsignedInt64 << " ..." << std::endl;
    return 0;
}
