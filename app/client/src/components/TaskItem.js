import { useContext } from 'react';
import TaskContext from '../context/TaskContext';

const TaskItem = ({ task }) => {
  const { deleteTask, updateTask } = useContext(TaskContext);

  const handleDelete = () => {
    deleteTask(task._id);
  };

  const toggleCompleted = () => {
    updateTask(task._id, { completed: !task.completed });
  };

  return (
    <div className={`task ${task.completed ? 'completed' : ''}`}>
      <div className="task-info">
        <h3>{task.title}</h3>
        <p>{task.description}</p>
        <small>
          Created: {new Date(task.createdAt).toLocaleDateString()}
        </small>
      </div>
      <div className="task-actions">
        <button onClick={toggleCompleted}>
          {task.completed ? 'Mark Incomplete' : 'Mark Complete'}
        </button>
        <button onClick={handleDelete}>Delete</button>
      </div>
    </div>
  );
};

export default TaskItem;