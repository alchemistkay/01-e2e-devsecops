import { useContext } from 'react';
import TaskForm from '../components/TaskForm';
import TaskList from '../components/TaskList';
import TaskContext from '../context/TaskContext';


const Home = () => {
  const { loading } = useContext(TaskContext);

  return (
    <div className="home">
      <div className="container">
        <div className="content">
          <div className="tasks">
            <TaskForm />
            <TaskList />
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;