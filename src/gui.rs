use std::sync::Arc;
use iced::widget::{button, column, container, row, text, text_input};
use iced::{Element, Length, Sandbox, Settings};
use crate::library_service::LibraryService;

pub struct AppFlags {
    pub library_service: Arc<LibraryService>,
}

#[derive(Debug, Default)]
pub struct LibraryApp {
    library_service: Option<Arc<LibraryService>>,
    current_view: View,
    book_title: String,
    book_author: String,
    book_category: String,
    search_query: String,
}

#[derive(Debug)]
enum Message {
    BookTitleChanged(String),
    BookAuthorChanged(String),
    BookCategoryChanged(String),
    SearchQueryChanged(String),
    AddBook,
    SearchBooks,
    ShowStats,
}

#[derive(Debug, Default)]
enum View {
    #[default]
    BookList,
    AddBook,
    SearchResults,
    Statistics,
}

impl Sandbox for LibraryApp {
    type Message = Message;

    fn new() -> Self {
        Self::default()
    }

    fn title(&self) -> String {
        String::from("Library Management System")
    }

    fn update(&mut self, message: Message) {
        match message {
            Message::BookTitleChanged(value) => self.book_title = value,
            Message::BookAuthorChanged(value) => self.book_author = value,
            Message::BookCategoryChanged(value) => self.book_category = value,
            Message::SearchQueryChanged(value) => self.search_query = value,
            Message::AddBook => self.current_view = View::AddBook,
            Message::SearchBooks => self.current_view = View::SearchResults,
            Message::ShowStats => self.current_view = View::Statistics,
        }
    }

    fn view(&self) -> Element<Message> {
        let content = match self.current_view {
            View::BookList => self.view_book_list(),
            View::AddBook => self.view_add_book(),
            View::SearchResults => self.view_search_results(),
            View::Statistics => self.view_statistics(),
        };

        container(content)
            .width(Length::Fill)
            .height(Length::Fill)
            .center_x()
            .center_y()
            .into()
    }
}

impl LibraryApp {
    fn view_book_list(&self) -> Element<Message> {
        column![
            text("Library Management System").size(40),
            row![
                button("Add Book").on_press(Message::AddBook),
                button("Search").on_press(Message::SearchBooks),
                button("Statistics").on_press(Message::ShowStats),
            ]
        ]
        .spacing(20)
        .into()
    }

    fn view_add_book(&self) -> Element<Message> {
        column![
            text("Add New Book").size(30),
            text_input("Title", &self.book_title)
                .on_input(Message::BookTitleChanged),
            text_input("Author", &self.book_author)
                .on_input(Message::BookAuthorChanged),
            text_input("Category", &self.book_category)
                .on_input(Message::BookCategoryChanged),
            button("Add Book").on_press(Message::AddBook)
        ]
        .spacing(10)
        .into()
    }

    fn view_search_results(&self) -> Element<Message> {
        column![
            text("Search Books").size(30),
            text_input("Search", &self.search_query)
                .on_input(Message::SearchQueryChanged),
            button("Search").on_press(Message::SearchBooks)
        ]
        .spacing(10)
        .into()
    }

    fn view_statistics(&self) -> Element<Message> {
        column![
            text("Library Statistics").size(30),
            // Statistics will be implemented later
        ]
        .spacing(10)
        .into()
    }
}
