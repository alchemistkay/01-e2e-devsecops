import { useContext, useEffect } from 'react';
import TaskContext from '../context/TaskContext';
import TaskItem from './TaskItem';
import Spinner from './Spinner';

const TaskList = () => {
  const { tasks, loading, error, getTasks } = useContext(TaskContext);
  

  useEffect(() => {
    getTasks();
  }, [getTasks]);

  if (loading) {
    return <Spinner />;
  }

  if (error) {
    return <div className="error">{error}</div>;
  }

  return (
    <div className="task-list">
      {tasks.length === 0 ? (
        <p>No tasks found. Add one to get started!</p>
      ) : (
        tasks.map((task) => <TaskItem key={task._id} task={task} />)
      )}
    </div>
  );
};

export default TaskList;