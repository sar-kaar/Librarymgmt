use rayon::prelude::*;
use dashmap::DashMap;
use std::sync::{Arc, atomic::{AtomicU64, Ordering}};
use crate::config::AppConfig;
use anyhow::Result;

pub struct DataProcessor {
    config: AppConfig,
    cache: Arc<DashMap<String, String>>,
    processed_count: Arc<AtomicU64>,
}

impl DataProcessor {
    pub fn new(config: AppConfig) -> Self {
        Self {
            config,
            cache: Arc::new(DashMap::new()),
            processed_count: Arc::new(AtomicU64::new(0)),
        }
    }
    
    pub fn process_batch_parallel(&self, data: Vec<String>) -> Result<Vec<String>> {
        let results: Vec<String> = data
            .par_iter()
            .map(|item| self.process_single_item(item))
            .collect::<Result<Vec<_>, _>>()?;
            
        self.processed_count.fetch_add(data.len() as u64, Ordering::Relaxed);
        Ok(results)
    }
    
    fn process_single_item(&self, data: &str) -> Result<String> {
        // Check cache first
        if let Some(cached) = self.cache.get(data) {
            return Ok(cached.clone());
        }
        
        // Perform heavy computation
        let processed = format!("processed_{}", data.len());
        
        // Cache result
        self.cache.insert(data.to_string(), processed.clone());
        
        Ok(processed)
    }
    
    pub fn get_stats(&self) -> ProcessorStats {
        ProcessorStats {
            processed_count: self.processed_count.load(Ordering::Relaxed),
            cache_size: self.cache.len(),
        }
    }
}

pub struct ProcessorStats {
    pub processed_count: u64,
    pub cache_size: usize,
}
