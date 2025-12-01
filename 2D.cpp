#include <iostream>
using namespace std;

int main() {
    int A[100][100], B[100][100], C[100][100];
    int r1, c1, r2, c2;

    // Input Matrix A
    cout << "Enter rows and cols of Matrix A: ";
    cin >> r1 >> c1;

    cout << "Enter elements of Matrix A:\n";
    for (int i = 0; i < r1; i++)
        for (int j = 0; j < c1; j++)
            cin >> A[i][j];

    // Input Matrix B
    cout << "Enter rows and cols of Matrix B: ";
    cin >> r2 >> c2;

    cout << "Enter elements of Matrix B:\n";
    for (int i = 0; i < r2; i++)
        for (int j = 0; j < c2; j++)
            cin >> B[i][j];

    // -------------------------------
    // Display both matrices
    // -------------------------------
    cout << "\nMatrix A:\n";
    for (int i = 0; i < r1; i++) {
        for (int j = 0; j < c1; j++)
            cout << A[i][j] << " ";
        cout << endl;
    }

    cout << "\nMatrix B:\n";
    for (int i = 0; i < r2; i++) {
        for (int j = 0; j < c2; j++)
            cout << B[i][j] << " ";
        cout << endl;
    }

    // -------------------------------
    // Matrix Addition (only if same size)
    // -------------------------------
    cout << "\nAddition Result:\n";
    if (r1 == r2 && c1 == c2) {
        for (int i = 0; i < r1; i++) {
            for (int j = 0; j < c1; j++) {
                C[i][j] = A[i][j] + B[i][j];
                cout << C[i][j] << " ";
            }
            cout << endl;
        }
    } else {
        cout << "Matrices cannot be added (size mismatch)\n";
    }

    // -------------------------------
    // Matrix Multiplication (c1 must equal r2)
    // -------------------------------
    cout << "\nMultiplication Result:\n";
    if (c1 == r2) {
        for (int i = 0; i < r1; i++) {
            for (int j = 0; j < c2; j++) {
                C[i][j] = 0;  // reset each cell
                for (int k = 0; k < c1; k++)
                    C[i][j] += A[i][k] * B[k][j];
                
                cout << C[i][j] << " ";
            }
            cout << endl;
        }
    } else {
        cout << "Matrices cannot be multiplied (column-row mismatch)\n";
    }

    return 0;
}
