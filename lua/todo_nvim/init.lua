
local db_fun = require("todo_nvim.db_functions")
DB_PATH = vim.fn.stdpath("config") .. "/todo_nvim"

local M = {}

local function setup()

    db_fun.setup_db(DB_PATH)

end

M.setup = setup

M.fetch_tasks = db_fun.fetch_tasks
M.add_task = db_fun.add_task
M.remove_task = db_fun.remove_task
M.complete_task = db_fun.complete_task

return M

