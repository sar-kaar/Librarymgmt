use sqlx::{Pool, Sqlite, SqlitePool, Row};
use anyhow::Result;
use chrono::Utc;
use uuid::Uuid;
use crate::models::*;

#[derive(Clone)]
pub struct Database {
    pool: Pool<Sqlite>,
}

impl Database {
    pub async fn new(database_url: &str) -> Result<Self> {
        println!("Connecting to database at: {}", database_url);
        let pool = SqlitePool::connect(database_url).await?;
        
        sqlx::query(
            r#"
            CREATE TABLE IF NOT EXISTS books (
                id TEXT PRIMARY KEY,
                title TEXT NOT NULL,
                author TEXT NOT NULL,
                isbn TEXT UNIQUE,
                publisher TEXT,
                published_year INTEGER,
                category TEXT NOT NULL,
                copies_total INTEGER NOT NULL DEFAULT 1,
                copies_available INTEGER NOT NULL DEFAULT 1,
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL
            );
            
            CREATE TABLE IF NOT EXISTS members (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                email TEXT UNIQUE NOT NULL,
                phone TEXT,
                address TEXT,
                membership_type TEXT NOT NULL DEFAULT 'standard',
                joined_date TEXT NOT NULL,
                is_active BOOLEAN NOT NULL DEFAULT 1
            );
            
            CREATE TABLE IF NOT EXISTS transactions (
                id TEXT PRIMARY KEY,
                book_id TEXT NOT NULL,
                member_id TEXT NOT NULL,
                transaction_type TEXT NOT NULL,
                transaction_date TEXT NOT NULL,
                due_date TEXT,
                return_date TEXT,
                fine_amount REAL,
                status TEXT NOT NULL DEFAULT 'active'
            );
            "#
        )
        .execute(&pool)
        .await?;
        
        Ok(Self { pool })
    }
    
    pub async fn add_book(&self, mut book: Book) -> Result<Book> {
        book.id = Uuid::new_v4().to_string();
        book.created_at = Utc::now();
        book.updated_at = Utc::now();
        
        sqlx::query(
            r#"INSERT INTO books (id, title, author, isbn, publisher, published_year, 
               category, copies_total, copies_available, created_at, updated_at)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"#
        )
        .bind(&book.id)
        .bind(&book.title)
        .bind(&book.author)
        .bind(&book.isbn)
        .bind(&book.publisher)
        .bind(book.published_year)
        .bind(&book.category)
        .bind(book.copies_total)
        .bind(book.copies_available)
        .bind(book.created_at.to_rfc3339())
        .bind(book.updated_at.to_rfc3339())
        .execute(&self.pool)
        .await?;
        
        Ok(book)
    }
    
    pub async fn add_member(&self, mut member: Member) -> Result<Member> {
        member.id = uuid::Uuid::new_v4().to_string();
        member.joined_date = Utc::now();
        
        sqlx::query(
            r#"INSERT INTO members (id, name, email, phone, address, membership_type, joined_date, is_active)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?)"#
        )
        .bind(&member.id)
        .bind(&member.name)
        .bind(&member.email)
        .bind(&member.phone)
        .bind(&member.address)
        .bind(&member.membership_type)
        .bind(member.joined_date.to_rfc3339())
        .bind(member.is_active)
        .execute(&self.pool)
        .await?;
        
        Ok(member)
    }
    
    pub async fn search_books(&self, query: &BookSearchQuery) -> Result<Vec<Book>> {
        let rows = sqlx::query("SELECT * FROM books WHERE title LIKE ?")
            .bind(format!("%{}%", query.title.as_deref().unwrap_or("")))
            .fetch_all(&self.pool)
            .await?;
        
        let mut books = Vec::new();
        for row in rows {
            books.push(Book {
                id: row.get("id"),
                title: row.get("title"),
                author: row.get("author"),
                isbn: row.get("isbn"),
                publisher: row.get("publisher"),
                published_year: row.get("published_year"),
                category: row.get("category"),
                copies_total: row.get("copies_total"),
                copies_available: row.get("copies_available"),
                created_at: row.get::<String, _>("created_at").parse()?,
                updated_at: row.get::<String, _>("updated_at").parse()?,
            });
        }
        Ok(books)
    }
    
    pub async fn get_library_stats(&self) -> Result<LibraryStats> {
        let total_books: (i64,) = sqlx::query_as("SELECT COUNT(*) FROM books")
            .fetch_one(&self.pool).await?;
        
        Ok(LibraryStats {
            total_books: total_books.0,
            total_members: 0,
            books_borrowed: 0,
            overdue_books: 0,
        })
    }
    
    pub async fn borrow_book(&self, book_id: &str, member_id: &str) -> Result<Transaction> {
        let mut tx = self.pool.begin().await?;
        
        let book: (i32,) = sqlx::query_as("SELECT copies_available FROM books WHERE id = ?")
            .bind(book_id)
            .fetch_one(&mut *tx)
            .await?;
            
        if book.0 <= 0 {
            return Err(anyhow::anyhow!("No copies available"));
        }
        
        sqlx::query("UPDATE books SET copies_available = copies_available - 1 WHERE id = ?")
            .bind(book_id)
            .execute(&mut *tx)
            .await?;
        
        let transaction = Transaction {
            id: Uuid::new_v4().to_string(),
            book_id: book_id.to_string(),
            member_id: member_id.to_string(),
            transaction_type: "borrow".to_string(),
            transaction_date: Utc::now(),
            due_date: Some(Utc::now() + chrono::Duration::days(14)),
            return_date: None,
            fine_amount: None,
            status: "active".to_string(),
        };
        
        sqlx::query(
            r#"INSERT INTO transactions (id, book_id, member_id, transaction_type, 
               transaction_date, due_date, status)
               VALUES (?, ?, ?, ?, ?, ?, ?)"#
        )
        .bind(&transaction.id)
        .bind(&transaction.book_id)
        .bind(&transaction.member_id)
        .bind(&transaction.transaction_type)
        .bind(transaction.transaction_date.to_rfc3339())
        .bind(transaction.due_date.unwrap().to_rfc3339())
        .bind(&transaction.status)
        .execute(&mut *tx)
        .await?;
        
        tx.commit().await?;
        Ok(transaction)
    }
}
