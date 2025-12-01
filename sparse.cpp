#include <iostream>
using namespace std;

int main() {
    int r, c;
    int mat[100][100];
    int triplet[100][3];  // store sparse matrix (row, col, value)
    int t = 0;            // count of non-zero elements

    // Input size
    cout << "Enter number of rows and columns: ";
    cin >> r >> c;

    // Input matrix
    cout << "Enter matrix elements:\n";
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            cin >> mat[i][j];

            if (mat[i][j] != 0) {
                triplet[t][0] = i;
                triplet[t][1] = j;
                triplet[t][2] = mat[i][j];
                t++;
            }
        }
    }

    // Display sparse matrix (triplet form)
    cout << "\nSparse Matrix (Triplet Form):\n";
    cout << "Row Col Val\n";
    for (int i = 0; i < t; i++) {
        cout << triplet[i][0] << "   "
             << triplet[i][1] << "   "
             << triplet[i][2] << endl;
    }

    // Transpose (swap row and col)
    int trans[100][3];
    for (int i = 0; i < t; i++) {
        trans[i][0] = triplet[i][1]; // swap row
        trans[i][1] = triplet[i][0]; // swap col
        trans[i][2] = triplet[i][2]; // same value
    }

    // Display transposed sparse matrix
    cout << "\nTranspose (Triplet Form):\n";
    cout << "Row Col Val\n";
    for (int i = 0; i < t; i++) {
        cout << trans[i][0] << "   "
             << trans[i][1] << "   "
             << trans[i][2] << endl;
    }

    return 0;
}
