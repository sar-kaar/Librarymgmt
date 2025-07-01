use serde::{Serialize, Deserialize};
use anyhow::Result;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AppConfig {
    pub database_url: String,
    pub max_borrow_days: i32,
    pub fine_per_day: f64,
}

impl Default for AppConfig {
    fn default() -> Self {
        Self {
            database_url: "sqlite:./data/library.db".to_string(),
            max_borrow_days: 14,
            fine_per_day: 0.50,
        }
    }
}

impl AppConfig {
    pub fn load() -> Result<Self> {
        // Try to load from config file, fallback to default
        Ok(Self::default())
    }
}
