#include <iostream>
#include <cstdint>
#include <limits>

int main() {
    uint64 myUnsignedInt64 = 6300000004;
    unsigned long long tester = 6300000004;

    std::cout << "Size of myUnsignedInt64: " << sizeof(myUnsignedInt64) << " bytes" << std::endl;
    std::cout << "Contents of myUnsignedInt64: " << myUnsignedInt64 << " ..." << std::endl;
    std::cout << "Maximum value of uint64_t: " << std::numeric_limits<uint64>::max() << std::endl;

    std::cout << "Size of u L L: " << sizeof(tester) << " bytes" << std::endl;
    std::cout << "Contents of u L L: " << tester << " ..." << std::endl;
    std::cout << "Maximum value of unsigned long long: " << std::numeric_limits<unsigned long long>::max() << std::endl;

    return 0;
}
