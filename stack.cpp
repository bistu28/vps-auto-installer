#include <iostream>
using namespace std;

#define MAX 5
int stackArr[MAX];
int top = -1;

// Push operation
void push(int value) {
    if (top == MAX - 1) {
        cout << "Stack Overflow!" << endl;
    } else {
        stackArr[++top] = value;
        cout << value << " pushed." << endl;
    }
}

// Pop operation
void pop() {
    if (top == -1) {
        cout << "Stack Underflow! No element to pop." << endl;
    } else {
        cout << stackArr[top] << " popped." << endl;
        top--;
    }
}

// TOP operation
void topElement() {
    if (top == -1) {
        cout << "Stack is empty!" << endl;
    } else {
        cout << "Top element is: " << stackArr[top] << endl;
    }
}

// Display stack elements
void display() {
    if (top == -1) {
        cout << "Stack is empty." << endl;
    } else {
        cout << "Stack elements (Top to Bottom): ";
        for (int i = top; i >= 0; i--)
            cout << stackArr[i] << " ";
        cout << endl;
    }
}

int main() {
    int value, numPop;

    cout << "Enter " << MAX << " elements to push into the stack:\n";
    for (int i = 0; i < MAX; i++) {
        cin >> value;
        push(value);
    }

    cout << "\nCurrent Stack:\n";
    display();

    cout << "\nCurrent TOP: ";
    topElement();

    // Ask user how many elements to pop
    cout << "\nHow many elements do you want to pop? ";
    cin >> numPop;

    for (int i = 0; i < numPop; i++)
        pop();

    cout << "\nStack after popping:\n";
    display();

    cout << "Current TOP: ";
    topElement();

    return 0;
}
