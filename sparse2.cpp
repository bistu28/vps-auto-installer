#include <iostream>
#include <vector>
using namespace std;

// Structure to store sparse matrix elements
struct Element {
    int row, col, value;
};

// Sparse matrix class using triplet representation
class SparseMatrix {
public:
    int rows, cols;
    vector<Element> data;

    // Constructor
    SparseMatrix(int r, int c) : rows(r), cols(c) {}

    // Add non-zero element
    void addElement(int r, int c, int val) {
        if (val != 0) data.push_back({r, c, val});
    }

    // Transpose of sparse matrix
    SparseMatrix transpose() const {
        SparseMatrix t(cols, rows);

        for (auto &e : data)
            t.data.push_back({e.col, e.row, e.value});

        return t;
    }

    // Display sparse matrix (triplet form)
    void display() const {
        cout << "Row Col Val\n";
        for (auto &e : data)
            cout << e.row << "   " << e.col << "   " << e.value << "\n";
    }
};

int main() {
    int r, c;
    cin >> r >> c;

    SparseMatrix s(r, c);

    int x;
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            cin >> x;
            if (x != 0) s.addElement(i, j, x);
        }
    }

    cout << "Original Sparse Matrix:\n";
    s.display();

    SparseMatrix t = s.transpose();
    cout << "\nTransposed Sparse Matrix:\n";
    t.display();

    return 0;
}