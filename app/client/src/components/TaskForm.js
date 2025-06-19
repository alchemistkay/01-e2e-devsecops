import { useState, useContext } from 'react';
import TaskContext from '../context/TaskContext';

const TaskForm = () => {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const { addTask } = useContext(TaskContext);

  const onSubmit = (e) => {
    e.preventDefault();
    addTask({ title, description });
    setTitle('');
    setDescription('');
  };

  return (
    <form onSubmit={onSubmit} className="task-form">
      <h2>Add Task</h2>
      <div className="form-control">
        <label htmlFor="title">Title</label>
        <input
          type="text"
          id="title"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          required
        />
      </div>
      <div className="form-control">
        <label htmlFor="description">Description</label>
        <textarea
          id="description"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          required
        />
      </div>
      <button type="submit">Add Task</button>
    </form>
  );
};

export default TaskForm;