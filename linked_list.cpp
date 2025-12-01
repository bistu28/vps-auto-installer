#include <iostream>
using namespace std;

struct Node {
    int data;
    Node* next;
};

Node* head = NULL;   // start of the list

// Insert at beginning
void insertBeginning(int value) {
    Node* newNode = new Node();
    newNode->data = value;
    newNode->next = head;
    head = newNode;
    cout << "Inserted at beginning.\n";
}

// Insert at end
void insertEnd(int value) {
    Node* newNode = new Node();
    newNode->data = value;
    newNode->next = NULL;

    if (head == NULL) {  
        head = newNode;
        cout << "Inserted at end.\n";
        return;
    }

    Node* temp = head;
    while (temp->next != NULL)
        temp = temp->next;

    temp->next = newNode;
    cout << "Inserted at end.\n";
}

// Delete a node
void deleteNode(int value) {
    if (head == NULL) {
        cout << "List is empty.\n";
        return;
    }

    // If first node is to be deleted
    if (head->data == value) {
        Node* temp = head;
        head = head->next;
        delete temp;
        cout << "Deleted.\n";
        return;
    }

    Node* temp = head;
    while (temp->next != NULL && temp->next->data != value)
        temp = temp->next;

    if (temp->next == NULL) {
        cout << "Value not found.\n";
        return;
    }

    Node* del = temp->next;
    temp->next = temp->next->next;
    delete del;
    cout << "Deleted.\n";
}

// Display linked list
void display() {
    if (head == NULL) {
        cout << "List is empty.\n";
        return;
    }

    Node* temp = head;
    cout << "List: ";
    while (temp != NULL) {
        cout << temp->data << " -> ";
        temp = temp->next;
    }
    cout << "NULL\n";
}

int main() {
    int choice, value;

    do {
        cout << "\n1. Insert at Beginning\n";
        cout << "2. Insert at End\n";
        cout << "3. Delete a Node\n";
        cout << "4. Display List\n";
        cout << "5. Exit\n";
        cout << "Enter your choice: ";
        cin >> choice;

        switch (choice) {
            case 1:
                cout << "Enter value: ";
                cin >> value;
                insertBeginning(value);
                break;

            case 2:
                cout << "Enter value: ";
                cin >> value;
                insertEnd(value);
                break;

            case 3:
                cout << "Enter value to delete: ";
                cin >> value;
                deleteNode(value);
                break;

            case 4:
                display();
                break;

            case 5:
                cout << "Exit.\n";
                break;

            default:
                cout << "Invalid choice.\n";
        }

    } while (choice != 5);

    return 0;
}
