use anyhow::Result;
use std::sync::Arc;
use tracing::info;
use iced::{Application, Settings};

mod database;
mod models;
mod library_service;
mod gui;

use database::Database;
use library_service::LibraryService;
use gui::LibraryApp;

#[tokio::main]
async fn main() -> Result<()> {
    tracing_subscriber::fmt::init();
    info!("Starting Library Management System");
    
    let db_path = "sqlite:library.db";
    std::fs::write("library.db", "")?;
    
    let db = Arc::new(Database::new(db_path).await?);
    let library_service = Arc::new(LibraryService::new(db.clone()));
    
    LibraryApp::run(Settings::default())
        .map_err(|e| anyhow::anyhow!("GUI Error: {}", e))?;

    Ok(())
}
        .map_err(|e| anyhow::anyhow!("GUI Error: {}", e))?;

    Ok(())
}

    async fn run(&self) -> Result<()> {
        self.run_cli().await?;
        Ok(())
    }
    
    async fn run_cli(&self) -> Result<()> {
        use std::io::{self, Write};
        
        loop {
            println!("\n=== Library Management System ===");
            println!("1. Add Book");
            println!("2. Search Books");
            println!("3. Add Member");
            println!("4. Borrow Book");
            println!("5. View Statistics");
            println!("6. Exit");
            print!("Choose an option: ");
            io::stdout().flush()?;
            
            let mut input = String::new();
            io::stdin().read_line(&mut input)?;
            
            match input.trim() {
                "1" => self.add_book_interactive().await?,
                "2" => self.search_books_interactive().await?,
                "3" => self.add_member_interactive().await?,
                "4" => self.borrow_book_interactive().await?,
                "5" => self.show_statistics().await?,
                "6" => break,
                _ => println!("Invalid option!"),
            }
        }
        Ok(())
    }
    
    async fn add_book_interactive(&self) -> Result<()> {
        use std::io::{self, Write};
        use crate::models::Book;
        use chrono::Utc;
        
        print!("Enter book title: ");
        io::stdout().flush()?;
        let mut title = String::new();
        io::stdin().read_line(&mut title)?;
        
        print!("Enter author: ");
        io::stdout().flush()?;
        let mut author = String::new();
        io::stdin().read_line(&mut author)?;
        
        print!("Enter category: ");
        io::stdout().flush()?;
        let mut category = String::new();
        io::stdin().read_line(&mut category)?;
        
        let book = Book {
            id: String::new(),
            title: title.trim().to_string(),
            author: author.trim().to_string(),
            isbn: None,
            publisher: None,
            published_year: None,
            category: category.trim().to_string(),
            copies_total: 1,
            copies_available: 1,
            created_at: Utc::now(),
            updated_at: Utc::now(),
        };
        
        match self.library_service.add_book(book).await {
            Ok(added_book) => println!("Book added successfully! ID: {}", added_book.id),
            Err(e) => eprintln!("Error adding book: {}", e),
        }
        
        Ok(())
    }
    
    async fn search_books_interactive(&self) -> Result<()> {
        use std::io::{self, Write};
        use crate::models::BookSearchQuery;
        
        print!("Enter search term (title): ");
        io::stdout().flush()?;
        let mut search_term = String::new();
        io::stdin().read_line(&mut search_term)?;
        
        let query = BookSearchQuery {
            title: if search_term.trim().is_empty() { None } else { Some(search_term.trim().to_string()) },
            author: None,
            category: None,
            isbn: None,
        };
        
        match self.library_service.search_books(&query).await {
            Ok(books) => {
                println!("\nFound {} books:", books.len());
                for book in books {
                    println!("- {} by {} (Available: {}/{})", 
                           book.title, book.author, book.copies_available, book.copies_total);
                }
            }
            Err(e) => eprintln!("Error searching books: {}", e),
        }
        
        Ok(())
    }
    
    async fn add_member_interactive(&self) -> Result<()> {
        use std::io::{self, Write};
        use crate::models::Member;
        use chrono::Utc;
        
        print!("Enter member name: ");
        io::stdout().flush()?;
        let mut name = String::new();
        io::stdin().read_line(&mut name)?;
        
        print!("Enter email: ");
        io::stdout().flush()?;
        let mut email = String::new();
        io::stdin().read_line(&mut email)?;
        
        print!("Enter phone (optional): ");
        io::stdout().flush()?;
        let mut phone = String::new();
        io::stdin().read_line(&mut phone)?;
        
        let member = Member {
            id: String::new(),
            name: name.trim().to_string(),
            email: email.trim().to_string(),
            phone: if phone.trim().is_empty() { None } else { Some(phone.trim().to_string()) },
            address: None,
            membership_type: "standard".to_string(),
            joined_date: Utc::now(),
            is_active: true,
        };
        
        match self.library_service.add_member(member).await {
            Ok(added_member) => println!("Member added successfully! ID: {}", added_member.id),
            Err(e) => eprintln!("Error adding member: {}", e),
        }
        
        Ok(())
    }
    
    async fn borrow_book_interactive(&self) -> Result<()> {
        use std::io::{self, Write};
        
        print!("Enter book ID to borrow: ");
        io::stdout().flush()?;
        let mut book_id = String::new();
        io::stdin().read_line(&mut book_id)?;
        
        print!("Enter member ID: ");
        io::stdout().flush()?;
        let mut member_id = String::new();
        io::stdin().read_line(&mut member_id)?;
        
        match self.library_service.borrow_book(book_id.trim(), member_id.trim()).await {
            Ok(transaction) => println!("Book borrowed successfully! Transaction ID: {}", transaction.id),
            Err(e) => eprintln!("Error borrowing book: {}", e),
        }
        Ok(())
    }
    
 



