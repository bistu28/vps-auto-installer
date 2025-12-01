#include <iostream>
using namespace std;

struct Node {
    int roll;
    string name;
    float marks;
    Node* prev;
    Node* next;
};

Node* head = NULL;
Node* tail = NULL;


// Insert at Beginning
void insertBeginning(int roll, string name, float marks) {
    Node* newNode = new Node();
    newNode->roll = roll;
    newNode->name = name;
    newNode->marks = marks;
    newNode->prev = NULL;
    newNode->next = head;

    if (head != NULL)
        head->prev = newNode;
    else
        tail = newNode; // list was empty

    head = newNode;
    cout << "Inserted at beginning.\n";
}


// Insert at End
void insertEnd(int roll, string name, float marks) {
    Node* newNode = new Node();
    newNode->roll = roll;
    newNode->name = name;
    newNode->marks = marks;
    newNode->next = NULL;
    newNode->prev = tail;

    if (tail != NULL)
        tail->next = newNode;
    else
        head = newNode; // list was empty

    tail = newNode;

    cout << "Inserted at end.\n";
}


// Delete by Roll
void deleteNode(int roll) {

    if (head == NULL) {
        cout << "List empty.\n";
        return;
    }

    Node* temp = head;

    // Find the roll number
    while (temp != NULL && temp->roll != roll)
        temp = temp->next;

    if (temp == NULL) {
        cout << "Roll not found.\n";
        return;
    }

    // Case 1: only one node
    if (head == tail) {
        head = tail = NULL;
    }
    // Case 2: deleting head
    else if (temp == head) {
        head = head->next;
        head->prev = NULL;
    }
    // Case 3: deleting tail
    else if (temp == tail) {
        tail = tail->prev;
        tail->next = NULL;
    }
    // Case 4: middle node
    else {
        temp->prev->next = temp->next;
        temp->next->prev = temp->prev;
    }

    delete temp;
    cout << "Deleted.\n";
}


// Display forward
void displayForward() {
    if (head == NULL) {
        cout << "No records.\n";
        return;
    }

    Node* temp = head;
    cout << "\nForward Traversal:\n";
    while (temp != NULL) {
        cout << temp->roll << " " << temp->name << " " << temp->marks << "\n";
        temp = temp->next;
    }
}


// Display backward
void displayBackward() {
    if (tail == NULL) {
        cout << "No records.\n";
        return;
    }

    Node* temp = tail;
    cout << "\nBackward Traversal:\n";
    while (temp != NULL) {
        cout << temp->roll << " " << temp->name << " " << temp->marks << "\n";
        temp = temp->prev;
    }
}


int main() {
    int roll, choice;
    string name;
    float marks;

    do {
        cout << "\n1. Insert at Beginning\n";
        cout << "2. Insert at End\n";
        cout << "3. Delete by Roll\n";
        cout << "4. Display Forward\n";
        cout << "5. Display Backward\n";
        cout << "6. Exit\n";
        cout << "Enter choice: ";
        cin >> choice;

        switch (choice) {

        case 1:
            cout << "Roll: "; cin >> roll;
            cout << "Name: "; cin >> name;
            cout << "Marks: "; cin >> marks;
            insertBeginning(roll, name, marks);
            break;

        case 2:
            cout << "Roll: "; cin >> roll;
            cout << "Name: "; cin >> name;
            cout << "Marks: "; cin >> marks;
            insertEnd(roll, name, marks);
            break;

        case 3:
            cout << "Enter roll to delete: ";
            cin >> roll;
            deleteNode(roll);
            break;

        case 4:
            displayForward();
            break;

        case 5:
            displayBackward();
            break;

        case 6:
            cout << "Exiting.\n";
            break;

        default:
            cout << "Invalid choice.\n";
        }

    } while (choice != 6);

    return 0;
}
