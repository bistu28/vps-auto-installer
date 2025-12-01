#include <iostream>
using namespace std;

// Insert element at a given position
void insertElement(int arr[], int &n, int element, int position, int capacity)
{
    if (n >= capacity)
    {
        cout << "Array is full.\n";
        return;
    }

    if (position < 0 || position > n)
    {
        cout << "Invalid Position.\n";
        return;
    }

    // Shift elements to right
    for (int i = n; i > position; i--)
        arr[i] = arr[i - 1];

    arr[position] = element;
    n++;

    cout << "Element Inserted.\n";
}

// Display array
void displayArray(int arr[], int n)
{
    if (n == 0)
    {
        cout << "Array is empty.\n";
        return;
    }

    cout << "Array: ";
    for (int i = 0; i < n; i++)
        cout << arr[i] << " ";
    cout << endl;
}

// Search an element
int searchElement(int arr[], int n, int element)
{
    for (int i = 0; i < n; i++)
    {
        if (arr[i] == element)
            return i;
    }
    return -1;
}

// Delete element from a position
void deleteElement(int arr[], int &n, int position)
{
    if (position < 0 || position >= n)
    {
        cout << "Invalid Position.\n";
        return;
    }

    for (int i = position; i < n - 1; i++)
        arr[i] = arr[i + 1];

    n--;
    cout << "Element Deleted.\n";
}

int main()
{
    int capacity = 100;
    int arr[100];
    int n;

    cout << "Enter number of elements: ";
    cin >> n;

    cout << "Enter " << n << " elements:\n";
    for (int i = 0; i < n; i++)
        cin >> arr[i];

    int choice;

    do
    {
        cout << "\n------ MENU ------\n";
        cout << "1. Insert Element\n";
        cout << "2. Display Array\n";
        cout << "3. Search Element\n";
        cout << "4. Delete Element\n";
        cout << "5. Exit\n";
        cout << "Enter your choice: ";
        cin >> choice;

        switch (choice)
        {
        case 1:
        {
            int element, position;
            cout << "Enter element: ";
            cin >> element;
            cout << "Enter position: ";
            cin >> position;
            insertElement(arr, n, element, position, capacity);
            break;
        }

        case 2:
            displayArray(arr, n);
            break;

        case 3:
        {
            int element;
            cout << "Enter element to search: ";
            cin >> element;

            int index = searchElement(arr, n, element);
            if (index != -1)
                cout << "Element found at index " << index << endl;
            else
                cout << "Element not found.\n";

            break;
        }

        case 4:
        {
            int position;
            cout << "Enter position to delete: ";
            cin >> position;
            deleteElement(arr, n, position);
            break;
        }

        case 5:
            cout << "Exiting...\n";
            break;

        default:
            cout << "Invalid choice!\n";
        }

    } while (choice != 5);

    return 0;
}
