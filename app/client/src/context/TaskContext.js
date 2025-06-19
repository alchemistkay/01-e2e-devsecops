import { createContext, useState, useEffect, useCallback } from 'react';
import axios from 'axios';

const TaskContext = createContext();

export const TaskProvider = ({ children }) => {
  const [tasks, setTasks] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // ✅ Memoized getTasks to avoid re-creation on every render
  const getTasks = useCallback(async () => {
    try {
      setLoading(true);
      const res = await axios.get('/api/tasks');
      setTasks(res.data.data);
      setLoading(false);
    } catch (err) {
      setError(err.response?.data?.error || 'Something went wrong');
      setLoading(false);
    }
  }, []); // no dependencies → safe and stable function reference

  // Fetch tasks on initial load
  useEffect(() => {
    getTasks(); // ✅ Now this won’t cause infinite re-renders
  }, [getTasks]);

  const addTask = async (task) => {
    try {
      setLoading(true);
      const res = await axios.post('/api/tasks', task);
      setTasks((prev) => [...prev, res.data.data]);
      setLoading(false);
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to add task');
      setLoading(false);
    }
  };

  const updateTask = async (id, updatedTask) => {
    try {
      setLoading(true);
      const res = await axios.put(`/api/tasks/${id}`, updatedTask);
      setTasks((prev) =>
        prev.map((task) => (task._id === id ? res.data.data : task))
      );
      setLoading(false);
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to update task');
      setLoading(false);
    }
  };

  const deleteTask = async (id) => {
    try {
      setLoading(true);
      await axios.delete(`/api/tasks/${id}`);
      setTasks((prev) => prev.filter((task) => task._id !== id));
      setLoading(false);
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to delete task');
      setLoading(false);
    }
  };

  return (
    <TaskContext.Provider
      value={{
        tasks,
        loading,
        error,
        getTasks,
        addTask,
        updateTask,
        deleteTask,
      }}
    >
      {children}
    </TaskContext.Provider>
  );
};

export default TaskContext;
