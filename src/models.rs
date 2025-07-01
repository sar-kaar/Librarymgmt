use serde::{Serialize, Deserialize};
use chrono::{DateTime, Utc};

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct Book {
    pub id: String,
    pub title: String,
    pub author: String,
    pub isbn: Option<String>,
    pub publisher: Option<String>,
    pub published_year: Option<i32>,
    pub category: String,
    pub copies_total: i32,
    pub copies_available: i32,
    pub created_at: DateTime<Utc>,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct Member {
    pub id: String,
    pub name: String,
    pub email: String,
    pub phone: Option<String>,
    pub address: Option<String>,
    pub membership_type: String,
    pub joined_date: DateTime<Utc>,
    pub is_active: bool,
}

#[derive(Debug, Clone, Serialize, Deserialize, sqlx::FromRow)]
pub struct Transaction {
    pub id: String,
    pub book_id: String,
    pub member_id: String,
    pub transaction_type: String, // "borrow" or "return"
    pub transaction_date: DateTime<Utc>,
    pub due_date: Option<DateTime<Utc>>,
    pub return_date: Option<DateTime<Utc>>,
    pub fine_amount: Option<f64>,
    pub status: String, // "active", "returned", "overdue"
}

#[derive(Debug, Serialize, Deserialize)]
pub struct BookSearchQuery {
    pub title: Option<String>,
    pub author: Option<String>,
    pub category: Option<String>,
    pub isbn: Option<String>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct LibraryStats {
    pub total_books: i64,
    pub total_members: i64,
    pub books_borrowed: i64,
    pub overdue_books: i64,
}
