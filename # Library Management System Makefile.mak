# Library Management System Makefile

CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -O2
LIBS = -lm
TARGET = library_mgmt
INSTALL_DIR = /usr/local/bin
CONFIG_DIR = /etc/library_mgmt
DATA_DIR = /var/lib/library_mgmt

SOURCES = main.c book_operations.c user_management.c borrowing.c utilities.c config.c reports.c
OBJECTS = $(SOURCES:.c=.o)
HEADERS = library.h

.PHONY: all clean install uninstall setup test

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(TARGET) $(LIBS)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)
	rm -f *.dat *.log
	rm -rf build/

install: $(TARGET)
	@echo "Installing Library Management System..."
	sudo mkdir -p $(INSTALL_DIR)
	sudo mkdir -p $(CONFIG_DIR)
	sudo mkdir -p $(DATA_DIR)
	sudo cp $(TARGET) $(INSTALL_DIR)/
	sudo cp library.conf.default $(CONFIG_DIR)/library.conf
	sudo chmod +x $(INSTALL_DIR)/$(TARGET)
	sudo chmod 755 $(CONFIG_DIR)
	sudo chmod 755 $(DATA_DIR)
	@echo "Creating desktop entry..."
	sudo cp library_mgmt.desktop /usr/share/applications/
	@echo "Installation completed successfully!"
	@echo "Run 'library_mgmt' to start the application"

uninstall:
	@echo "Uninstalling Library Management System..."
	sudo rm -f $(INSTALL_DIR)/$(TARGET)
	sudo rm -rf $(CONFIG_DIR)
	sudo rm -f /usr/share/applications/library_mgmt.desktop
	@echo "Uninstallation completed!"
	@echo "Note: Data directory $(DATA_DIR) preserved"

setup:
	@echo "Setting up development environment..."
	mkdir -p build
	mkdir -p tests
	cp library.conf.default library.conf

test: $(TARGET)
	@echo "Running tests..."
	./tests/run_tests.sh

package: clean
	@echo "Creating distribution package..."
	mkdir -p build/library_mgmt-1.0
	cp -r *.c *.h Makefile README.md LICENSE build/library_mgmt-1.0/
	cp -r configs/ docs/ tests/ build/library_mgmt-1.0/
	cd build && tar -czf library_mgmt-1.0.tar.gz library_mgmt-1.0/
	@echo "Package created: build/library_mgmt-1.0.tar.gz"

help:
	@echo "Available targets:"
	@echo "  all      - Build the application"
	@echo "  clean    - Remove build files"
	@echo "  install  - Install system-wide"
	@echo "  uninstall- Remove installation"
	@echo "  setup    - Setup development environment"
	@echo "  test     - Run tests"
	@echo "  package  - Create distribution package"
	@echo "  help     - Show this help"
