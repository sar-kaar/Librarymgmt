#ifndef LIBRARY_H
#define LIBRARY_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <ctype.h>
#include <unistd.h>

// Constants
#define MAX_TITLE 100
#define MAX_AUTHOR 50
#define MAX_ISBN 20
#define MAX_USERNAME 30
#define MAX_PASSWORD 50
#define MAX_NAME 50
#define FILENAME "books.dat"
#define USERS_FILE "users.dat"
#define LOG_FILE "library.log"
#define CONFIG_FILE "library.conf"

// User roles
typedef enum {
    MEMBER = 1,
    LIBRARIAN = 2,
    ADMIN = 3
} UserRole;

// Structures
typedef struct {
    int id;
    char title[MAX_TITLE];
    char author[MAX_AUTHOR];
    char isbn[MAX_ISBN];
    int year;
    float price;
    int isAvailable;
    char borrowedBy[MAX_USERNAME];
    time_t borrowDate;
    time_t returnDate;
} Book;

typedef struct {
    int id;
    char username[MAX_USERNAME];
    char password[MAX_PASSWORD];
    char fullName[MAX_NAME];
    UserRole role;
    int isActive;
    time_t createdDate;
    time_t lastLogin;
} User;

typedef struct {
    int id;
    int bookId;
    char username[MAX_USERNAME];
    time_t borrowDate;
    time_t returnDate;
    int isReturned;
    float fine;
} Transaction;

typedef struct {
    char dbPath[256];
    int maxBorrowDays;
    float finePerDay;
    int maxBooksPerUser;
    char libraryName[100];
    char adminEmail[100];
} Config;

// Global variables
extern User currentUser;
extern Config config;
extern int isLoggedIn;

// Book operations
void addBook();
void viewBooks();
void searchBook();
void deleteBook();
void updateBook();
int getNextId();
int isBookExists(const char* isbn);
void printBookDetails(const Book* book);

// User management
int login();
void logout();
void registerUser();
void viewUsers();
void deleteUser();
void changePassword();
int hasPermission(UserRole requiredRole);
char* getCurrentUser();
void createDefaultAdmin();

// Borrowing system
void borrowBook();
void returnBook();
void viewBorrowedBooks();
void viewOverdueBooks();
float calculateFine(time_t borrowDate, time_t returnDate);

// Utility functions
void clearScreen();
void printHeader(const char* title);
void printLine(int length);
void printSuccess(const char* message, ...);
void printError(const char* message, ...);
void printWarning(const char* message, ...);
void logActivity(const char* activity, ...);
void logError(const char* error, ...);
char* strcasestr(const char* haystack, const char* needle);

// Menu functions
void showMainMenu();
void showBookMenu();
void showUserMenu();
void showReportsMenu();

// Configuration
void loadConfig();
void saveConfig();
void showSettings();

// Reports
void generateBookReport();
void generateUserReport();
void generateTransactionReport();

// Installation and setup
void setupDatabase();
void installLibrary();

#endif
