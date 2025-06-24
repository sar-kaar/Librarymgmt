const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

// In-memory todos list
let todos = [
  { id: 1, task: 'Learn Node.js', done: false }
];

// GET all todos
app.get('/todos', (req, res) => {
  res.json(todos);
});

// GET a single todo
app.get('/todos/:id', (req, res) => {
  const todo = todos.find(t => t.id === parseInt(req.params.id));
  if (!todo) return res.status(404).json({ error: 'Todo not found' });
  res.json(todo);
});

// CREATE a new todo
app.post('/todos', (req, res) => {
  const { task } = req.body;
  if (!task) return res.status(400).json({ error: 'Task is required' });

  const newTodo = {
    id: todos.length + 1,
    task,
    done: false
  };

  todos.push(newTodo);
  res.status(201).json(newTodo);
});

// UPDATE a todo
app.put('/todos/:id', (req, res) => {
  const todo = todos.find(t => t.id === parseInt(req.params.id));
  if (!todo) return res.status(404).json({ error: 'Todo not found' });

  const { task, done } = req.body;
  if (task !== undefined) todo.task = task;
  if (done !== undefined) todo.done = done;

  res.json(todo);
});

// DELETE a todo
app.delete('/todos/:id', (req, res) => {
  const index = todos.findIndex(t => t.id === parseInt(req.params.id));
  if (index === -1) return res.status(404).json({ error: 'Todo not found' });

  todos.splice(index, 1);
  res.status(204).send();
});

// Start server
app.listen(port, () => {
  console.log(`Todo API running at http://localhost:${port}`);
});