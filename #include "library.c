#include "library.h"

Config config;

int main() {
    // Initialize system
    loadConfig();
    setupDatabase();
    
    printf("=================================================\n");
    printf("    Welcome to %s\n", config.libraryName);
    printf("=================================================\n");
    printf("Initializing system...\n");
    sleep(2);
    
    // Main application loop
    while (1) {
        if (!isLoggedIn) {
            clearScreen();
            printf("=== Library Management System ===\n");
            printf("1. Login\n");
            printf("2. Exit\n");
            printf("Enter your choice: ");
            
            int choice;
            if (scanf("%d", &choice) != 1) {
                printError("Invalid input!");
                continue;
            }
            
            switch (choice) {
                case 1:
                    if (login()) {
                        showMainMenu();
                    }
                    break;
                case 2:
                    printf("Thank you for using Library Management System!\n");
                    exit(0);
                default:
                    printError("Invalid choice!");
                    sleep(1);
            }
        } else {
            showMainMenu();
        }
    }
    
    return 0;
}

void showMainMenu() {
    while (isLoggedIn) {
        clearScreen();
        printf("=== Library Management System ===\n");
        printf("Welcome, %s (%s)\n\n", currentUser.fullName, 
               currentUser.role == ADMIN ? "Administrator" : 
               currentUser.role == LIBRARIAN ? "Librarian" : "Member");
        
        printf("1. Book Management\n");
        printf("2. Borrowing System\n");
        
        if (hasPermission(LIBRARIAN)) {
            printf("3. User Management\n");
            printf("4. Reports\n");
        }
        
        if (hasPermission(ADMIN)) {
            printf("5. System Settings\n");
        }
        
        printf("8. Change Password\n");
        printf("9. Logout\n");
        printf("0. Exit\n");
        
        printf("\nEnter your choice: ");
        
        int choice;
        if (scanf("%d", &choice) != 1) {
            printError("Invalid input!");
            continue;
        }
        
        switch (choice) {
            case 1:
                showBookMenu();
                break;
            case 2:
                showBorrowingMenu();
                break;
            case 3:
                if (hasPermission(LIBRARIAN)) {
                    showUserMenu();
                } else {
                    printError("Access denied!");
                }
                break;
            case 4:
                if (hasPermission(LIBRARIAN)) {
                    showReportsMenu();
                } else {
                    printError("Access denied!");
                }
                break;
            case 5:
                if (hasPermission(ADMIN)) {
                    showSettings();
                } else {
                    printError("Access denied!");
                }
                break;
            case 8:
                changePassword();
                break;
            case 9:
                logout();
                return;
            case 0:
                printf("Thank you for using Library Management System!\n");
                exit(0);
            default:
                printError("Invalid choice!");
                sleep(1);
        }
    }
}

void showBookMenu() {
    while (1) {
        clearScreen();
        printHeader("BOOK MANAGEMENT");
        
        printf("1. Add New Book\n");
        printf("2. View All Books\n");
        printf("3. Search Books\n");
        
        if (hasPermission(LIBRARIAN)) {
            printf("4. Update Book\n");
        }
        
        if (hasPermission(ADMIN)) {
            printf("5. Delete Book\n");
        }
        
        printf("0. Back to Main Menu\n");
        
        printf("\nEnter your choice: ");
        
        int choice;
        if (scanf("%d", &choice) != 1) {
            printError("Invalid input!");
            continue;
        }
        
        switch (choice) {
            case 1:
                addBook();
                break;
            case 2:
                viewBooks();
                break;
            case 3:
                searchBook();
                break;
            case 4:
                if (hasPermission(LIBRARIAN)) {
                    updateBook();
                } else {
                    printError("Access denied!");
                }
                break;
            case 5:
                if (hasPermission(ADMIN)) {
                    deleteBook();
                } else {
                    printError("Access denied!");
                }
                break;
            case 0:
                return;
            default:
                printError("Invalid choice!");
                sleep(1);
        }
    }
}

void showUserMenu() {
    while (1) {
        clearScreen();
        printHeader("USER MANAGEMENT");
        
        printf("1. Register New User\n");
        printf("2. View All Users\n");
        
        if (hasPermission(ADMIN)) {
            printf("3. Delete User\n");
            printf("4. Activate/Deactivate User\n");
        }
        
        printf("0. Back to Main Menu\n");
        
        printf("\nEnter your choice: ");
        
        int choice;
        if (scanf("%d", &choice) != 1) {
            printError("Invalid input!");
            continue;
        }
        
        switch (choice) {
            case 1:
                registerUser();
                break;
            case 2:
                viewUsers();
                break;
            case 3:
                if (hasPermission(ADMIN)) {
                    deleteUser();
                } else {
                    printError("Access denied!");
                }
                break;
            case 4:
                if (hasPermission(ADMIN)) {
                    toggleUserStatus();
                } else {
                    printError("Access denied!");
                }
                break;
            case 0:
                return;
            default:
                printError("Invalid choice!");
                sleep(1);
        }
    }
}

void showBorrowingMenu() {
    while (1) {
        clearScreen();
        printHeader("BORROWING SYSTEM");
        
        printf("1. Borrow Book\n");
        printf("2. Return Book\n");
        printf("3. View My Borrowed Books\n");
        
        if (hasPermission(LIBRARIAN)) {
            printf("4. View All Borrowed Books\n");
            printf("5. View Overdue Books\n");
        }
        
        printf("0. Back to Main Menu\n");
        
        printf("\nEnter your choice: ");
        
        int choice;
        if (scanf("%d", &choice) != 1) {
            printError("Invalid input!");
            continue;
        }
        
        switch (choice) {
            case 1:
                borrowBook();
                break;
            case 2:
                returnBook();
                break;
            case 3:
                viewBorrowedBooks();
                break;
            case 4:
                if (hasPermission(LIBRARIAN)) {
                    viewAllBorrowedBooks();
                } else {
                    printError("Access denied!");
                }
                break;
            case 5:
                if (hasPermission(LIBRARIAN)) {
                    viewOverdueBooks();
                } else {
                    printError("Access denied!");
                }
                break;
            case 0:
                return;
            default:
                printError("Invalid choice!");
                sleep(1);
        }
    }
}
