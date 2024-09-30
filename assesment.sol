import React, { useState, useEffect } from "react";
import { ethers } from "ethers";
import AssessmentABI from "../artifacts/contracts/Assessment.sol/Assessment.json";

const CONTRACT_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

const App = () => {
  const [tasks, setTasks] = useState([]);
  const [newTask, setNewTask] = useState("");
  const [contract, setContract] = useState(null);

  useEffect(() => {
    const init = async () => {
      try {
        const web3Provider = new ethers.providers.Web3Provider(window.ethereum);
        await web3Provider.send("eth_requestAccounts", []);
        const signer = web3Provider.getSigner();
        const todoContract = new ethers.Contract(CONTRACT_ADDRESS, AssessmentABI.abi, signer);

        setContract(todoContract);

        const fetchedTasks = await todoContract.getTasks();
        setTasks(fetchedTasks);
      } catch (error) {
        console.error("Initialization error:", error);
      }
    };

    init();
  }, []);

  const handleAddTask = async () => {
    try {
      const tx = await contract.addTask(newTask);
      await tx.wait();
      const updatedTasks = await contract.getTasks();
      setTasks(updatedTasks);
      setNewTask("");
    } catch (error) {
      console.error("Add Task error:", error);
    }
  };

  return (
    <div>
      <h1>To-Do List Dapp!</h1>
      <ul>
        {tasks.map((task, index) => (
          <li key={index}>{task}</li>
        ))}
      </ul>

      <div>
        <input
          type="text"
          value={newTask}
          onChange={(e) => setNewTask(e.target.value)}
          placeholder="Enter new task"
        />
        <button onClick={handleAddTask}>Add Task</button>
      </div>
    </div>
  );
};

export default App;
