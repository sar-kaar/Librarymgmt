use std::sync::Arc;
use anyhow::Result;
use crate::database::Database;
use crate::models::*;

pub struct LibraryService {
    db: Arc<Database>,
}

impl LibraryService {
    pub fn new(db: Arc<Database>) -> Self {
        Self { db }
    }
    
    pub async fn add_book(&self, book: Book) -> Result<Book> {
        self.db.add_book(book).await
    }
    
    pub async fn search_books(&self, query: &BookSearchQuery) -> Result<Vec<Book>> {
        self.db.search_books(query).await
    }
    
    pub async fn borrow_book(&self, book_id: &str, member_id: &str) -> Result<Transaction> {
        self.db.borrow_book(book_id, member_id).await
    }
    
    pub async fn get_statistics(&self) -> Result<LibraryStats> {
        self.db.get_library_stats().await
    }
    
    pub async fn add_member(&self, member: Member) -> Result<Member> {
        self.db.add_member(member).await
    }
}
