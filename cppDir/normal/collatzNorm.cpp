#include <iostream>

using namespace std;

int main(int argc, char* argv[]) {
    int lowerLimit = -1;
    int upperLimit = -1; 

    if (argc == 2) {
        lowerLimit = argv[1];
    } else if (argc == 3) {
        lowerLimit = argv[1];
        upperLimit = argv[2];
    }

    cout << lowerLimit << endl;
    cout << upperLimit << endl;

    return 0;
}
