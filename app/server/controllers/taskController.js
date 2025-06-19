const Task = require('../models/Task');

// @desc    Get all tasks
// @route   GET /api/tasks
// @access  Public
exports.getTasks = async (req, res, next) => {
  try {
    const tasks = await Task.find();
    res.status(200).json({ success: true, count: tasks.length, data: tasks });
  } catch (err) {
    res.status(400).json({ success: false });
  }
};

// @desc    Get single task
// @route   GET /api/tasks/:id
// @access  Public
exports.getTask = async (req, res, next) => {
  try {
    const task = await Task.findById(req.params.id);
    
    if (!task) {
      return res.status(404).json({ success: false });
    }
    
    res.status(200).json({ success: true, data: task });
  } catch (err) {
    res.status(400).json({ success: false });
  }
};

// @desc    Create task
// @route   POST /api/tasks
// @access  Public
exports.createTask = async (req, res, next) => {
  try {
    const task = await Task.create(req.body);
    res.status(201).json({ success: true, data: task });
  } catch (err) {
    res.status(400).json({ success: false, error: err.message });
  }
};

// @desc    Update task
// @route   PUT /api/tasks/:id
// @access  Public
exports.updateTask = async (req, res, next) => {
  try {
    const task = await Task.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    
    if (!task) {
      return res.status(404).json({ success: false });
    }
    
    res.status(200).json({ success: true, data: task });
  } catch (err) {
    res.status(400).json({ success: false });
  }
};

// @desc    Delete task
// @route   DELETE /api/tasks/:id
// @access  Public
exports.deleteTask = async (req, res, next) => {
  try {
    const task = await Task.findByIdAndDelete(req.params.id);
    
    if (!task) {
      return res.status(404).json({ success: false });
    }
    
    res.status(200).json({ success: true, data: {} });
  } catch (err) {
    res.status(400).json({ success: false });
  }
};